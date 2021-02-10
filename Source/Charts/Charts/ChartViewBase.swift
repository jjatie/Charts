//
//  ChartViewBase.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//
//  Based on https://github.com/PhilJay/MPAndroidChart/commit/c42b880

import CoreGraphics
import Foundation

#if !os(OSX)
    import UIKit
#endif

public protocol ChartViewDelegate: AnyObject {
    /// Called when a value has been selected inside the chart.
    ///
    /// - Parameters:
    ///   - entry: The selected Entry.
    ///   - highlight: The corresponding highlight object that contains information about the highlighted position such as dataSetIndex etc.
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)

    /// Called when a user stops panning between values on the chart
    func chartViewDidEndPanning(_ chartView: ChartViewBase)

    // Called when nothing has been selected or an "un-select" has been made.
    func chartValueNothingSelected(_ chartView: ChartViewBase)

    // Callbacks when the chart is scaled / zoomed via pinch zoom gesture.
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat)

    // Callbacks when the chart is moved / translated via drag gesture.
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat)

    // Callbacks when Animator stops animating
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator)
}

open class ChartViewBase: NSUIView {
    // MARK: - Properties

    /// The default IValueFormatter that has been determined by the chart considering the provided minimum and maximum values.
    internal lazy var defaultValueFormatter: ValueFormatter = DefaultValueFormatter(decimals: 0)

    /// object that holds all data that was originally set for the chart, before it was modified or any filtering algorithms had been applied
    open var data: ChartData? {
        didSet {
            offsetsCalculated = false

            guard let data = data else { return }

            // calculate how many digits are needed
            setupDefaultFormatter(min: data.yRange.min, max: data.yRange.max)

            for set in data where set.valueFormatter is DefaultValueFormatter {
                set.valueFormatter = defaultValueFormatter
            }

            // let the chart know there is new data
            notifyDataSetChanged()
        }
    }

    /// If set to true, chart continues to scroll after touch up
    public var isDragDecelerationEnabled = true

    /// The object representing the labels on the x-axis
    public internal(set) lazy var xAxis = XAxis()

    /// The `Description` object of the chart.
    public lazy var chartDescription = Description()

    /// The legend object containing all data associated with the legend
    open internal(set) lazy var legend = Legend()

    /// delegate to receive chart events
    open weak var delegate: ChartViewDelegate?

    /// text that is displayed when the chart is empty
    open var noDataText = "No chart data available."

    /// Font to be used for the no data text.
    open var noDataFont = NSUIFont.systemFont(ofSize: 12)

    /// color of the no data text
    open var noDataTextColor: NSUIColor = .labelOrBlack

    /// alignment of the no data text
    open var noDataTextAlignment: TextAlignment = .left

    /// The renderer object responsible for rendering / drawing the Legend.
    open lazy var legendRenderer = LegendRenderer(viewPortHandler: viewPortHandler, legend: legend)

    /// object responsible for rendering the data
    open var renderer: DataRenderer?

    open var highlighter: Highlighter?

    /// The ViewPortHandler of the chart that is responsible for the
    /// content area of the chart and its offsets and dimensions.
    open internal(set) lazy var viewPortHandler = ViewPortHandler(width: bounds.size.width, height: bounds.size.height)

    /// The animator responsible for animating chart values.
    lazy var chartAnimator: Animator = {
        let animator = Animator()
        animator.delegate = self
        return animator
    }()

    /// flag that indicates if offsets calculation has already been done or not
    private var offsetsCalculated = false

    /// The array of currently highlighted values. This might an empty if nothing is highlighted.
    open internal(set) var highlighted = [Highlight]()

    /// `true` if drawing the marker is enabled when tapping on values
    /// (use the `marker` property to specify a marker)
    open var drawMarkers = true

    /// - Returns: `true` if drawing the marker is enabled when tapping on values
    /// (use the `marker` property to specify a marker)
    open var isDrawMarkersEnabled: Bool { return drawMarkers }

    /// The marker that is displayed when a value is clicked on the chart
    open var marker: Marker?

    /// An extra offset to be appended to the viewport's top
    open var extraTopOffset: CGFloat = 0.0

    /// An extra offset to be appended to the viewport's right
    open var extraRightOffset: CGFloat = 0.0

    /// An extra offset to be appended to the viewport's bottom
    open var extraBottomOffset: CGFloat = 0.0

    /// An extra offset to be appended to the viewport's left
    open var extraLeftOffset: CGFloat = 0.0

    open func setExtraOffsets(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        extraLeftOffset = left
        extraTopOffset = top
        extraRightOffset = right
        extraBottomOffset = bottom
    }

    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    deinit {
        removeObserver(self, forKeyPath: "bounds")
        removeObserver(self, forKeyPath: "frame")
    }

    internal func initialize() {
        #if os(iOS)
            backgroundColor = .clear
        #endif

        addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
        addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }

    // MARK: - ChartViewBase

    /// Lets the chart know its underlying data has changed and should perform all necessary recalculations.
    /// It is crucial that this method is called everytime data is changed dynamically. Not calling this method can lead to crashes or unexpected behaviour.
    open func notifyDataSetChanged() {
        fatalError("notifyDataSetChanged() cannot be called on ChartViewBase")
    }

    /// Calculates the offsets of the chart to the border depending on the position of an eventual legend or depending on the length of the y-axis and x-axis labels and their position
    internal func calculateOffsets() {
        fatalError("calculateOffsets() cannot be called on ChartViewBase")
    }

    /// calculates the required number of digits for the values that might be drawn in the chart (if enabled), and creates the default value formatter
    internal func setupDefaultFormatter(min: Double, max: Double) {
        // check if a custom formatter is set or not
        var reference = 0.0

        if let data = data, data.entryCount >= 2 {
            reference = abs(max - min)
        } else {
            reference = Swift.max(abs(min), abs(max))
        }

        if let formatter = defaultValueFormatter as? DefaultValueFormatter {
            // setup the formatter with a new number of digits
            let digits = reference.decimalPlaces
            formatter.decimals = digits
        }
    }

    override open func draw(_: CGRect) {
        guard let context = NSUIGraphicsGetCurrentContext() else { return }

        if data === nil, !noDataText.isEmpty {
            context.saveGState()
            defer { context.restoreGState() }

            let paragraphStyle = MutableParagraphStyle.default.mutableCopy() as! MutableParagraphStyle
            paragraphStyle.minimumLineHeight = noDataFont.lineHeight
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = noDataTextAlignment

            context.drawMultilineText(noDataText,
                                      at: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0),
                                      constrainedTo: bounds.size,
                                      anchor: CGPoint(x: 0.5, y: 0.5),
                                      angleRadians: 0.0,
                                      attributes: [.font: noDataFont,
                                                   .foregroundColor: noDataTextColor,
                                                   .paragraphStyle: paragraphStyle])

            return
        }

        if !offsetsCalculated {
            calculateOffsets()
            offsetsCalculated = true
        }
    }

    /// Draws the description text in the bottom right corner of the chart (per default)
    internal func drawDescription(in context: CGContext) {
        let description = chartDescription

        // check if description should be drawn
        guard
            description.isEnabled,
            let descriptionText = description.text,
            !descriptionText.isEmpty
        else { return }

        let position = description.position ?? CGPoint(x: bounds.width - viewPortHandler.offsetRight - description.xOffset,
                                                       y: bounds.height - viewPortHandler.offsetBottom - description.yOffset - description.font.lineHeight)

        let attrs: [NSAttributedString.Key: Any] = [
            .font: description.font,
            .foregroundColor: description.textColor,
        ]

        context.drawText(descriptionText,
                         at: position,
                         align: description.textAlign,
                         attributes: attrs)
    }

    // MARK: - Accessibility

    override open func accessibilityChildren() -> [Any]? {
        return renderer?.accessibleChartElements
    }

    // MARK: - Highlighting

    /// Set this to false to prevent values from being highlighted by tap gesture.
    /// Values can still be highlighted via drag or programmatically.
    /// **default**: true
    public var isHighLightPerTapEnabled: Bool = true

    /// Checks if the highlight array is null, has a length of zero or if the first object is null.
    ///
    /// - Returns: `true` if there are values to highlight, `false` ifthere are no values to highlight.
    public final var valuesToHighlight: Bool {
        !highlighted.isEmpty
    }

    /// Highlights the values at the given indices in the given DataSets. Provide
    /// null or an empty array to undo all highlighting.
    /// This should be used to programmatically highlight values.
    /// This method *will not* call the delegate.
    public final func highlightValues(_ highs: [Highlight]?) {
        // set the indices to highlight
        highlighted = highs ?? []

        lastHighlighted = highlighted.first

        // redraw the chart
        setNeedsDisplay()
    }

    /// Highlights the value at the given x-value and y-value in the given DataSet.
    /// Provide -1 as the dataSetIndex to undo all highlighting.
    ///
    /// - Parameters:
    ///   - x: The x-value to highlight
    ///   - y: The y-value to highlight. Supply `NaN` for "any"
    ///   - dataSetIndex: The dataset index to search in
    ///   - dataIndex: The data index to search in (only used in CombinedChartView currently)
    ///   - callDelegate: Should the delegate be called for this change
    public final func highlightValue(x: Double, y: Double = .nan, dataSetIndex: Int, dataIndex: Int = -1, callDelegate: Bool = true)
    {
        guard let data = data else {
            Swift.print("Value not highlighted because data is nil")
            return
        }

        if data.indices.contains(dataSetIndex) {
            highlightValue(Highlight(x: x, y: y, dataSetIndex: dataSetIndex, dataIndex: dataIndex), callDelegate: callDelegate)
        } else {
            highlightValue(nil, callDelegate: callDelegate)
        }
    }

    /// Highlights the value selected by touch gesture.
    public final func highlightValue(_ highlight: Highlight?, callDelegate: Bool = false) {
        var high = highlight
        guard
            let h = high,
            let entry = data?.entry(for: h)
        else {
            high = nil
            highlighted.removeAll(keepingCapacity: false)
            if callDelegate {
                delegate?.chartValueNothingSelected(self)
            }
            return
        }

        // set the indices to highlight
        highlighted = [h]

        if callDelegate {
            // notify the listener
            delegate?.chartValueSelected(self, entry: entry, highlight: h)
        }

        // redraw the chart
        setNeedsDisplay()
    }

    /// - Returns: The Highlight object (contains x-index and DataSet index) of the
    /// selected value at the given touch point inside the Line-, Scatter-, or
    /// CandleStick-Chart.
    open func getHighlightByTouchPoint(_ pt: CGPoint) -> Highlight? {
        guard data != nil else {
            Swift.print("Can't select by touch. No data set.")
            return nil
        }

        return highlighter?.getHighlight(x: pt.x, y: pt.y)
    }

    /// The last value that was highlighted via touch.
    open var lastHighlighted: Highlight?

    // MARK: - Markers

    /// draws all MarkerViews on the highlighted positions
    func drawMarkers(context: CGContext) {
        // if there is no marker view or drawing marker is disabled
        guard let marker = marker,
              isDrawMarkersEnabled,
              valuesToHighlight
        else { return }

        for highlight in highlighted {
            guard let set = data?[highlight.dataSetIndex],
                let e = data?.entry(for: highlight),
                let entryIndex = set.firstIndex(of: e),
                entryIndex <= Int(Double(set.count) * chartAnimator.phaseX)
            else { continue }

            let pos = getMarkerPosition(highlight: highlight)

            // check bounds
            guard viewPortHandler.isInBounds(x: pos.x, y: pos.y) else { continue }

            // callbacks to update the content
            marker.refreshContent(entry: e, highlight: highlight)

            // draw the marker
            marker.draw(context: context, point: pos)
        }
    }

    /// - Returns: The actual position in pixels of the MarkerView for the given Entry in the given DataSet.
    public func getMarkerPosition(highlight: Highlight) -> CGPoint {
        CGPoint(x: highlight.drawX, y: highlight.drawY)
    }

    // MARK: - Animation

    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - xAxisDuration: duration for animating the x axis
    ///   - yAxisDuration: duration for animating the y axis
    ///   - easingX: an easing function for the animation on the x axis
    ///   - easingY: an easing function for the animation on the y axis
    public final func animate(xAxisDuration: TimeInterval, yAxisDuration: TimeInterval, easingX: ChartEasingFunctionBlock?, easingY: ChartEasingFunctionBlock?)
    {
        chartAnimator.animate(xAxisDuration: xAxisDuration, yAxisDuration: yAxisDuration, easingX: easingX, easingY: easingY)
    }

    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - xAxisDuration: duration for animating the x axis
    ///   - yAxisDuration: duration for animating the y axis
    ///   - easingOptionX: the easing function for the animation on the x axis
    ///   - easingOptionY: the easing function for the animation on the y axis
    public final func animate(xAxisDuration: TimeInterval, yAxisDuration: TimeInterval, easingOptionX: ChartEasingOption, easingOptionY: ChartEasingOption)
    {
        chartAnimator.animate(xAxisDuration: xAxisDuration, yAxisDuration: yAxisDuration, easingOptionX: easingOptionX, easingOptionY: easingOptionY)
    }

    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - xAxisDuration: duration for animating the x axis
    ///   - yAxisDuration: duration for animating the y axis
    ///   - easing: an easing function for the animation
    public final func animate(xAxisDuration: TimeInterval, yAxisDuration: TimeInterval, easing: ChartEasingFunctionBlock?)
    {
        chartAnimator.animate(xAxisDuration: xAxisDuration, yAxisDuration: yAxisDuration, easing: easing)
    }

    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - xAxisDuration: duration for animating the x axis
    ///   - yAxisDuration: duration for animating the y axis
    ///   - easingOption: the easing function for the animation
    public final func animate(xAxisDuration: TimeInterval, yAxisDuration: TimeInterval, easingOption: ChartEasingOption = .easeInOutSine)
    {
        chartAnimator.animate(xAxisDuration: xAxisDuration, yAxisDuration: yAxisDuration, easingOption: easingOption)
    }

    /// Animates the drawing / rendering of the chart the x-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - xAxisDuration: duration for animating the x axis
    ///   - easing: an easing function for the animation
    public final func animate(xAxisDuration: TimeInterval, easing: ChartEasingFunctionBlock?) {
        chartAnimator.animate(xAxisDuration: xAxisDuration, easing: easing)
    }

    /// Animates the drawing / rendering of the chart the x-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - xAxisDuration: duration for animating the x axis
    ///   - easingOption: the easing function for the animation
    public final func animate(xAxisDuration: TimeInterval, easingOption: ChartEasingOption = .easeInOutSine) {
        chartAnimator.animate(xAxisDuration: xAxisDuration, easingOption: easingOption)
    }

    /// Animates the drawing / rendering of the chart the y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - yAxisDuration: duration for animating the y axis
    ///   - easing: an easing function for the animation
    public final func animate(yAxisDuration: TimeInterval, easing: ChartEasingFunctionBlock?) {
        chartAnimator.animate(yAxisDuration: yAxisDuration, easing: easing)
    }

    /// Animates the drawing / rendering of the chart the y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    ///
    /// - Parameters:
    ///   - yAxisDuration: duration for animating the y axis
    ///   - easingOption: the easing function for the animation
    public final func animate(yAxisDuration: TimeInterval, easingOption: ChartEasingOption = .easeInOutSine) {
        chartAnimator.animate(yAxisDuration: yAxisDuration, easingOption: easingOption)
    }

    // MARK: - Accessors

    /// The center of the chart taking offsets under consideration. (returns the center of the content rectangle)
    public final var centerOffsets: CGPoint {
        viewPortHandler.contentCenter
    }

    /// The rectangle that defines the borders of the chart-value surface (into which the actual values are drawn).
    public final var contentRect: CGRect {
        viewPortHandler.contentRect
    }

    private var _viewportJobs = [ViewPortJob]()

    override open func observeValue(forKeyPath keyPath: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?)
    {
        if keyPath == "bounds" || keyPath == "frame" {
            let bounds = self.bounds

            if bounds.size.width != viewPortHandler.chartWidth ||
                bounds.size.height != viewPortHandler.chartHeight
            {
                viewPortHandler.setChartDimens(width: bounds.size.width, height: bounds.size.height)

                // This may cause the chart view to mutate properties affecting the view port -- lets do this
                // before we try to run any pending jobs on the view port itself
                notifyDataSetChanged()

                // Finish any pending viewport changes
                while !_viewportJobs.isEmpty {
                    let job = _viewportJobs.remove(at: 0)
                    job.doJob()
                }
            }
        }
    }

    public final func addViewportJob(_ job: ViewPortJob) {
        if viewPortHandler.hasChartDimens {
            job.doJob()
        } else {
            _viewportJobs.append(job)
        }
    }

    public final func removeViewportJob(_ job: ViewPortJob) {
        if let index = _viewportJobs.firstIndex(where: { $0 === job }) {
            _viewportJobs.remove(at: index)
        }
    }

    /// Deceleration friction coefficient in [0 ; 1] interval, higher values indicate that speed will decrease slowly, for example if it set to 0, it will stop immediately.
    /// 1 is an invalid value, and will be converted to 0.999 automatically.
    public final var dragDecelerationFrictionCoef: CGFloat {
        get { _dragDecelerationFrictionCoef }
        set { _dragDecelerationFrictionCoef = newValue.clamped(to: 0...0.999) }
    }
    private var _dragDecelerationFrictionCoef: CGFloat = 0.9

    /// The maximum distance in screen pixels away from an entry causing it to highlight.
    /// **default**: 500.0
    public final var maxHighlightDistance: CGFloat = 500.0
}

    // MARK: - AnimatorDelegate
extension ChartViewBase: AnimatorDelegate {
    public final func animatorUpdated(_: Animator) {
        setNeedsDisplay()
    }

    public final func animatorStopped(_ chartAnimator: Animator) {
        delegate?.chartView(self, animatorDidStop: chartAnimator)
    }
}
