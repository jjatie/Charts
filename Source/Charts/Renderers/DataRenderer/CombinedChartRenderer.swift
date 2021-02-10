////
////  CombinedChartRenderer.swift
////  Charts
////
////  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
////  A port of MPAndroidChart for iOS
////  Licensed under Apache License 2.0
////
////  https://github.com/danielgindi/Charts
////
//
//import CoreGraphics
//import Foundation
//
//open class CombinedChartRenderer: DataRenderer {
//    public let viewPortHandler: ViewPortHandler
//
//    public final var accessibleChartElements: [NSUIAccessibilityElement] = []
//
//    public let animator: Animator
//
//    open weak var chart: CombinedChartView?
//
//    /// if set to true, all values are drawn above their bars, instead of below their top
//    open var drawValueAboveBarEnabled = true
//
//    /// if set to true, a grey area is drawn behind each bar that indicates the maximum value
//    open var drawBarShadowEnabled = false
//
//    internal var _renderers = [DataRenderer]()
//
//    internal var _drawOrder: [CombinedChartView.DrawOrder] = [.bar, .bubble, .line, .candle, .scatter]
//
//    public init(chart: CombinedChartView, animator: Animator, viewPortHandler: ViewPortHandler) {
//        self.chart = chart
//        self.viewPortHandler = viewPortHandler
//        self.animator = animator
//
//        createRenderers()
//    }
//
//    /// Creates the renderers needed for this combined-renderer in the required order. Also takes the DrawOrder into consideration.
//    internal func createRenderers() {
//        _renderers = [DataRenderer]()
//
//        guard let chart = chart else { return }
//
//        for order in drawOrder {
//            switch order {
//            case .bar:
//                if chart.barData !== nil {
//                    _renderers.append(BarChartRenderer(chart: chart, animator: animator, viewPortHandler: viewPortHandler))
//                }
//
//            case .line:
//                if chart.lineData !== nil {
//                    _renderers.append(LineChartRenderer(chart: chart, animator: animator, viewPortHandler: viewPortHandler))
//                }
//
//            case .candle:
//                if chart.candleData !== nil {
//                    _renderers.append(CandleStickChartRenderer(chart: chart, animator: animator, viewPortHandler: viewPortHandler))
//                }
//
//            case .scatter:
//                if chart.scatterData !== nil {
//                    _renderers.append(ScatterChartRenderer(chart: chart, animator: animator, viewPortHandler: viewPortHandler))
//                }
//
//            case .bubble:
//                if chart.bubbleData !== nil {
//                    _renderers.append(BubbleChartRenderer(chart: chart, animator: animator, viewPortHandler: viewPortHandler))
//                }
//            }
//        }
//    }
//
//    open func initBuffers() {
//        _renderers.forEach { $0.initBuffers() }
//    }
//
//    open func drawData(context: CGContext) {
//        // If we redraw the data, remove and repopulate accessible elements to update label values and frames
//        accessibleChartElements.removeAll()
//
//        if
//            let combinedChart = chart,
//            let data = combinedChart.data
//        {
//            // Make the chart header the first element in the accessible elements array
//            let element = createAccessibleHeader(usingChart: combinedChart,
//                                                 andData: data,
//                                                 withDefaultDescription: "Combined Chart")
//            accessibleChartElements.append(element)
//        }
//
//        // TODO: Due to the potential complexity of data presented in Combined charts, a more usable way
//        // for VO accessibility would be to use axis based traversal rather than by dataset.
//        // Hence, accessibleChartElements is not populated below. (Individual renderers guard against dataSource being their respective views)
//        _renderers.forEach { $0.drawData(context: context) }
//    }
//
//    open func drawValues(context: CGContext) {
//        _renderers.forEach { $0.drawValues(context: context) }
//    }
//
//    open func drawExtras(context: CGContext) {
//        _renderers.forEach { $0.drawExtras(context: context) }
//    }
//
//    open func drawHighlighted(context: CGContext, indices: [Highlight]) {
//        for renderer in _renderers {
//            var data: ChartData?
//
//            if renderer is BarChartRenderer {
//                data = (renderer as! BarChartRenderer).chart?.barData
//            } else if renderer is LineChartRenderer {
//                data = (renderer as! LineChartRenderer).chart?.lineData
//            } else if renderer is CandleStickChartRenderer {
//                data = (renderer as! CandleStickChartRenderer).chart?.candleData
//            } else if renderer is ScatterChartRenderer {
//                data = (renderer as! ScatterChartRenderer).chart?.scatterData
//            } else if renderer is BubbleChartRenderer {
//                data = (renderer as! BubbleChartRenderer).chart?.bubbleData
//            }
//
//            let dataIndex = data.map { data in
//                (chart?.data as? CombinedChartData)?.allData.firstIndex { $0 === data }
//            }
//
//            let dataIndices = indices.filter { $0.dataIndex == dataIndex || $0.dataIndex == -1 }
//
//            renderer.drawHighlighted(context: context, indices: dataIndices)
//        }
//    }
//
//    /// All sub-renderers.
//    open var subRenderers: [DataRenderer] {
//        get { return _renderers }
//        set { _renderers = newValue }
//    }
//
//    // MARK: Accessors
//
//    /// `true` if drawing values above bars is enabled, `false` ifnot
//    open var isDrawValueAboveBarEnabled: Bool { return drawValueAboveBarEnabled }
//
//    /// `true` if drawing shadows (maxvalue) for each bar is enabled, `false` ifnot
//    open var isDrawBarShadowEnabled: Bool { return drawBarShadowEnabled }
//
//    /// the order in which the provided data objects should be drawn.
//    /// The earlier you place them in the provided array, the further they will be in the background.
//    /// e.g. if you provide [DrawOrder.Bar, DrawOrder.Line], the bars will be drawn behind the lines.
//    open var drawOrder: [CombinedChartView.DrawOrder] {
//        get { _drawOrder }
//        set {
//            if !newValue.isEmpty {
//                _drawOrder = newValue
//            }
//        }
//    }
//}