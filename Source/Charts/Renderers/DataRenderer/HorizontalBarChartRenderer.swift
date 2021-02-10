//
//  HorizontalBarChartRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import CoreGraphics
import Foundation

#if !os(OSX)
    import UIKit
#endif

public class HorizontalBarChartRenderer: DataRenderer {
    public let viewPortHandler: ViewPortHandler

    public final var accessibleChartElements: [NSUIAccessibilityElement] = []

    public let animator: Animator

    let xBounds = XBounds()

    final lazy var accessibilityOrderedElements: [[NSUIAccessibilityElement]] = accessibilityCreateEmptyOrderedElements()

    typealias Buffer = [CGRect]

    public weak var chart: HorizontalBarChartView?

    public init(
        chart: HorizontalBarChartView,
        animator: Animator,
        viewPortHandler: ViewPortHandler
    ) {
        self.viewPortHandler = viewPortHandler
        self.animator = animator
        self.chart = chart
    }

    // [CGRect] per dataset
    private var _buffers = [Buffer]()

    public func initBuffers() {
        if let barData = chart?.data {
            // Matche buffers count to dataset count
            if _buffers.count != barData.count {
                while _buffers.count < barData.count {
                    _buffers.append(Buffer())
                }
                while _buffers.count > barData.count {
                    _buffers.removeLast()
                }
            }

            for (i, set) in barData.indexed() {
                let size = set.count * (set.isStacked ? set.stackSize : 1)
                if _buffers[i].count != size {
                    _buffers[i] = [CGRect](repeating: CGRect(), count: size)
                }
            }
        } else {
            _buffers.removeAll()
        }
    }

    private func prepareBuffer(dataSet: BarChartDataSet, index: Int) {
        guard let chart = chart else { return }

        let barWidthHalf = chart.barWidth / 2.0

        var bufferIndex = 0
        let containsStacks = dataSet.isStacked

        let isInverted = chart.isInverted(axis: dataSet.axisDependency)
        let phaseY = animator.phaseY
        var barRect = CGRect()
        var x: Double
        var y: Double

        for i in stride(from: 0, to: min(Int(ceil(Double(dataSet.count) * animator.phaseX)), dataSet.count), by: 1)
        {
            let e = dataSet[i]
            let vals = e.yValues

            x = e.x
            y = e.y

            if !containsStacks || vals == nil {
                let bottom = CGFloat(x - barWidthHalf)
                let top = CGFloat(x + barWidthHalf)
                var right = isInverted
                    ? (y <= 0.0 ? CGFloat(y) : 0)
                    : (y >= 0.0 ? CGFloat(y) : 0)
                var left = isInverted
                    ? (y >= 0.0 ? CGFloat(y) : 0)
                    : (y <= 0.0 ? CGFloat(y) : 0)

                // multiply the height of the rect with the phase
                if right > 0 {
                    right *= CGFloat(phaseY)
                } else {
                    left *= CGFloat(phaseY)
                }

                barRect.origin.x = left
                barRect.size.width = right - left
                barRect.origin.y = top
                barRect.size.height = bottom - top

                _buffers[index][bufferIndex] = barRect
                bufferIndex += 1
            } else {
                var posY = 0.0
                var negY = -e.negativeSum
                var yStart = 0.0

                // fill the stack
                for k in vals!.indices {
                    let value = vals![k]

                    if value == 0.0, posY == 0.0 || negY == 0.0 {
                        // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
                        y = value
                        yStart = y
                    } else if value >= 0.0 {
                        y = posY
                        yStart = posY + value
                        posY = yStart
                    } else {
                        y = negY
                        yStart = negY + abs(value)
                        negY += abs(value)
                    }

                    let bottom = CGFloat(x - barWidthHalf)
                    let top = CGFloat(x + barWidthHalf)
                    var right = isInverted
                        ? (y <= yStart ? CGFloat(y) : CGFloat(yStart))
                        : (y >= yStart ? CGFloat(y) : CGFloat(yStart))
                    var left = isInverted
                        ? (y >= yStart ? CGFloat(y) : CGFloat(yStart))
                        : (y <= yStart ? CGFloat(y) : CGFloat(yStart))

                    // multiply the height of the rect with the phase
                    right *= CGFloat(phaseY)
                    left *= CGFloat(phaseY)

                    barRect.origin.x = left
                    barRect.size.width = right - left
                    barRect.origin.y = top
                    barRect.size.height = bottom - top

                    _buffers[index][bufferIndex] = barRect
                    bufferIndex += 1
                }
            }
        }
    }

    // TODO: DUPLICATE FROM BarChartRenderer
    public func drawData(context: CGContext) {
        guard let chart = chart else { return }
        let barData = chart.data

        // If we redraw the data, remove and repopulate accessible elements to update label values and frames
        accessibleChartElements.removeAll()
        accessibilityOrderedElements = accessibilityCreateEmptyOrderedElements()

        // Make the chart header the first element in the accessible elements array
        let element = createAccessibleHeader(
            usingChart: chart,
            andData: barData,
            withDefaultDescription: "Bar Chart"
        )
        accessibleChartElements.append(element)

        // Populate logically ordered nested elements into accessibilityOrderedElements in drawDataSet()
        for (i, set) in barData.indexed() where set.isVisible {
            drawDataSet(context: context, dataSet: set, index: i)
        }

        // Merge nested ordered arrays into the single accessibleChartElements.
        accessibleChartElements.append(contentsOf: accessibilityOrderedElements.flatMap { $0 })
        accessibilityPostLayoutChangedNotification()
    }
    private var _barShadowRectBuffer = CGRect()

    public func drawDataSet(context: CGContext, dataSet: BarChartDataSet, index: Int) {
        guard let chart = chart else { return }

        let trans = chart.getTransformer(forAxis: dataSet.axisDependency)

        prepareBuffer(dataSet: dataSet, index: index)
        trans.rectValuesToPixel(&_buffers[index])

        let borderWidth = dataSet.barBorderWidth
        let borderColor = dataSet.barBorderColor
        let drawBorder = borderWidth > 0.0

        context.saveGState()

        // draw the bar shadow before the values
        if chart.isDrawBarShadowEnabled {
            let barWidth = chart.barWidth
            let barWidthHalf = barWidth / 2.0
            var x: Double = 0.0

            for i in stride(from: 0, to: min(Int(ceil(Double(dataSet.count) * animator.phaseX)), dataSet.count), by: 1)
            {
                let e = dataSet[i]
                x = e.x

                _barShadowRectBuffer.origin.y = CGFloat(x - barWidthHalf)
                _barShadowRectBuffer.size.height = CGFloat(barWidth)

                trans.rectValueToPixel(&_barShadowRectBuffer)

                if !viewPortHandler.isInBoundsTop(_barShadowRectBuffer.origin.y + _barShadowRectBuffer.size.height)
                {
                    break
                }

                if !viewPortHandler.isInBoundsBottom(_barShadowRectBuffer.origin.y) {
                    continue
                }

                _barShadowRectBuffer.origin.x = viewPortHandler.contentLeft
                _barShadowRectBuffer.size.width = viewPortHandler.contentWidth

                context.setFillColor(dataSet.barShadowColor.cgColor)
                context.fill(_barShadowRectBuffer)
            }
        }

        let buffer = _buffers[index]

        let isSingleColor = dataSet.colors.count == 1

        if isSingleColor {
            context.setFillColor(dataSet.color(at: 0).cgColor)
        }

        // In case the chart is stacked, we need to accomodate individual bars within accessibilityOrdereredElements
        let isStacked = dataSet.isStacked
        let stackSize = isStacked ? dataSet.stackSize : 1

        for (j, barRect) in buffer.indexed() {
            if !viewPortHandler.isInBoundsTop(barRect.origin.y + barRect.size.height) {
                break
            }

            if !viewPortHandler.isInBoundsBottom(barRect.origin.y) {
                continue
            }

            if !isSingleColor {
                // Set the color for the currently drawn value. If the index is out of bounds, reuse colors.
                context.setFillColor(dataSet.color(at: j).cgColor)
            }

            context.fill(barRect)

            if drawBorder {
                context.setStrokeColor(borderColor.cgColor)
                context.setLineWidth(borderWidth)
                context.stroke(barRect)
            }

            // Create and append the corresponding accessibility element to accessibilityOrderedElements (see BarChartRenderer)
            let element = createAccessibleElement(withIndex: j,
                                                  container: chart,
                                                  dataSet: dataSet,
                                                  dataSetIndex: index,
                                                  stackSize: stackSize) { element in
                element.accessibilityFrame = barRect
            }

            accessibilityOrderedElements[j / stackSize].append(element)
        }

        context.restoreGState()
    }

    public func prepareBarHighlight(
        x: Double,
        y1: Double,
        y2: Double,
        barWidthHalf: Double,
        trans: Transformer,
        rect: inout CGRect
    ) {
        let top = x - barWidthHalf
        let bottom = x + barWidthHalf
        let left = y1
        let right = y2

        rect.origin.x = CGFloat(left)
        rect.origin.y = CGFloat(top)
        rect.size.width = CGFloat(right - left)
        rect.size.height = CGFloat(bottom - top)

        trans.rectValueToPixelHorizontal(&rect, phaseY: animator.phaseY)
    }

    public func drawValues(context: CGContext) {
        // if values are drawn
        guard let chart = chart,
              isDrawingValuesAllowed(chart: chart)
        else {
            return
        }
        let barData = chart.data

        let textAlign = TextAlignment.left

        let valueOffsetPlus: CGFloat = 5.0
        var posOffset: CGFloat
        var negOffset: CGFloat
        let drawValueAboveBar = chart.isDrawValueAboveBarEnabled

        for (index, dataSet) in barData.indexed() where shouldDrawValues(forDataSet: dataSet) {
            let angleRadians = dataSet.valueLabelAngle.DEG2RAD

            let isInverted = chart.isInverted(axis: dataSet.axisDependency)

            let valueFont = dataSet.valueFont
            let yOffset = -valueFont.lineHeight / 2.0

            let formatter = dataSet.valueFormatter

            let trans = chart.getTransformer(forAxis: dataSet.axisDependency)

            let phaseY = animator.phaseY

            let iconsOffset = dataSet.iconsOffset

            let buffer = _buffers[index]

            // if only single values are drawn (sum)
            if !dataSet.isStacked {
                let range = 0 ..< Int(ceil(Double(dataSet.count) * animator.phaseX))
                for (j, e) in dataSet[range].indexed() {
                    let rect = buffer[j]

                    let y = rect.origin.y + rect.size.height / 2.0

                    if !viewPortHandler.isInBoundsTop(rect.origin.y) {
                        break
                    }

                    if !viewPortHandler.isInBoundsX(rect.origin.x) {
                        continue
                    }

                    if !viewPortHandler.isInBoundsBottom(rect.origin.y) {
                        continue
                    }

                    let val = e.y
                    let valueText = formatter.stringForValue(
                        val,
                        entry: e,
                        dataSetIndex: index,
                        viewPortHandler: viewPortHandler
                    )

                    // calculate the correct offset depending on the draw position of the value
                    let valueTextWidth = valueText.size(withAttributes: [.font: valueFont]).width
                    posOffset = (drawValueAboveBar ? valueOffsetPlus : -(valueTextWidth + valueOffsetPlus))
                    negOffset = (drawValueAboveBar ? -(valueTextWidth + valueOffsetPlus) : valueOffsetPlus) - rect.size.width

                    if isInverted {
                        posOffset = -posOffset - valueTextWidth
                        negOffset = -negOffset - valueTextWidth
                    }

                    if dataSet.isDrawValuesEnabled {
                        drawValue(
                            context: context,
                            value: valueText,
                            xPos: (rect.origin.x + rect.size.width)
                                + (val >= 0.0 ? posOffset : negOffset),
                            yPos: y + yOffset,
                            font: valueFont,
                            align: textAlign,
                            color: dataSet.valueTextColorAt(j),
                            anchor: CGPoint.zero,
                            angleRadians: angleRadians
                        )
                    }

                    if let icon = e.icon, dataSet.isDrawIconsEnabled {
                        var px = (rect.origin.x + rect.size.width)
                            + (val >= 0.0 ? posOffset : negOffset)
                        var py = y

                        px += iconsOffset.x
                        py += iconsOffset.y

                        context.drawImage(icon,
                                          atCenter: CGPoint(x: px, y: py),
                                          size: icon.size)
                    }
                }
            } else {
                // if each value of a potential stack should be drawn

                var bufferIndex = 0

                let range = 0 ..< Int(ceil(Double(dataSet.count) * animator.phaseX))
                for (index, e) in dataSet[range].indexed() {
                    let rect = buffer[bufferIndex]

                    let vals = e.yValues

                    // we still draw stacked bars, but there is one non-stacked in between
                    if vals == nil {
                        if !viewPortHandler.isInBoundsTop(rect.origin.y) {
                            break
                        }

                        if !viewPortHandler.isInBoundsX(rect.origin.x) {
                            continue
                        }

                        if !viewPortHandler.isInBoundsBottom(rect.origin.y) {
                            continue
                        }

                        let val = e.y
                        let valueText = formatter.stringForValue(
                            val,
                            entry: e,
                            dataSetIndex: index,
                            viewPortHandler: viewPortHandler
                        )

                        // calculate the correct offset depending on the draw position of the value
                        let valueTextWidth = valueText.size(withAttributes: [NSAttributedString.Key.font: valueFont]).width
                        posOffset = (drawValueAboveBar ? valueOffsetPlus : -(valueTextWidth + valueOffsetPlus))
                        negOffset = (drawValueAboveBar ? -(valueTextWidth + valueOffsetPlus) : valueOffsetPlus)

                        if isInverted {
                            posOffset = -posOffset - valueTextWidth
                            negOffset = -negOffset - valueTextWidth
                        }

                        if dataSet.isDrawValuesEnabled {
                            drawValue(
                                context: context,
                                value: valueText,
                                xPos: (rect.origin.x + rect.size.width)
                                    + (val >= 0.0 ? posOffset : negOffset),
                                yPos: rect.origin.y + yOffset,
                                font: valueFont,
                                align: textAlign,
                                color: dataSet.valueTextColorAt(index),
                                anchor: CGPoint.zero,
                                angleRadians: angleRadians
                            )
                        }

                        if let icon = e.icon, dataSet.isDrawIconsEnabled {
                            var px = (rect.origin.x + rect.size.width)
                                + (val >= 0.0 ? posOffset : negOffset)
                            var py = rect.origin.y

                            px += iconsOffset.x
                            py += iconsOffset.y

                            context.drawImage(icon,
                                              atCenter: CGPoint(x: px, y: py),
                                              size: icon.size)
                        }
                    } else {
                        let vals = vals!
                        var transformed = [CGPoint]()

                        var posY = 0.0
                        var negY = -e.negativeSum

                        for k in vals.indices {
                            let value = vals[k]
                            var y: Double

                            if value == 0.0, posY == 0.0 || negY == 0.0 {
                                // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
                                y = value
                            } else if value >= 0.0 {
                                posY += value
                                y = posY
                            } else {
                                y = negY
                                negY -= value
                            }

                            transformed.append(CGPoint(x: CGFloat(y * phaseY), y: 0.0))
                        }

                        trans.pointValuesToPixel(&transformed)

                        for k in transformed.indices {
                            let val = vals[k]
                            let valueText = formatter.stringForValue(
                                val,
                                entry: e,
                                dataSetIndex: index,
                                viewPortHandler: viewPortHandler
                            )

                            // calculate the correct offset depending on the draw position of the value
                            let valueTextWidth = valueText.size(withAttributes: [.font: valueFont]).width
                            posOffset = (drawValueAboveBar ? valueOffsetPlus : -(valueTextWidth + valueOffsetPlus))
                            negOffset = (drawValueAboveBar ? -(valueTextWidth + valueOffsetPlus) : valueOffsetPlus)

                            if isInverted {
                                posOffset = -posOffset - valueTextWidth
                                negOffset = -negOffset - valueTextWidth
                            }

                            let drawBelow = (val == 0.0 && negY == 0.0 && posY > 0.0) || val < 0.0

                            let x = transformed[k].x + (drawBelow ? negOffset : posOffset)
                            let y = rect.origin.y + rect.size.height / 2.0

                            if !viewPortHandler.isInBoundsTop(y) {
                                break
                            }

                            if !viewPortHandler.isInBoundsX(x) {
                                continue
                            }

                            if !viewPortHandler.isInBoundsBottom(y) {
                                continue
                            }

                            if dataSet.isDrawValuesEnabled {
                                drawValue(context: context,
                                          value: valueText,
                                          xPos: x,
                                          yPos: y + yOffset,
                                          font: valueFont,
                                          align: textAlign,
                                          color: dataSet.valueTextColorAt(index),
                                          anchor: CGPoint.zero,
                                          angleRadians: angleRadians)
                            }

                            if let icon = e.icon, dataSet.isDrawIconsEnabled {
                                context.drawImage(icon,
                                                  atCenter: CGPoint(x: x + iconsOffset.x,
                                                                    y: y + iconsOffset.y),
                                                  size: icon.size)
                            }
                        }
                    }

                    bufferIndex += vals?.count ?? 1
                }
            }
        }
    }

    // TODO: DUPLICATE FROM BarChartRenderer
    /// Draws a value at the specified x and y position.
    public func drawValue(context: CGContext, value: String, xPos: CGFloat, yPos: CGFloat, font: NSUIFont, align: TextAlignment, color: NSUIColor, anchor: CGPoint, angleRadians: CGFloat)
    {
        if angleRadians == 0.0 {
            context.drawText(value, at: CGPoint(x: xPos, y: yPos), align: align, attributes: [.font: font, .foregroundColor: color])
        } else {
            // align left to center text with rotation
            context.drawText(value, at: CGPoint(x: xPos, y: yPos), align: align, anchor: anchor, angleRadians: angleRadians, attributes: [.font: font, .foregroundColor: color])
        }
    }

    public func isDrawingValuesAllowed<Entry: ChartDataEntry>(chart: ChartViewBase<Entry>) -> Bool {
        let data = chart.data
        return data.entryCount < Int(CGFloat(chart.maxVisibleCount) * viewPortHandler.scaleY)
    }

    // TODO: DUPLICATE FROM BarChartRenderer
    public func drawHighlighted(context: CGContext, indices: [Highlight]) {
        guard let chart = chart else { return }
        let barData = chart.data

        context.saveGState()
        defer { context.restoreGState() }
        var barRect = CGRect()

        for high in indices {
            let set = barData[high.dataSetIndex]
            guard set.isHighlightingEnabled else { continue }

            if let e = set.element(withX: high.x, closestToY: high.y) {
                guard isInBoundsX(entry: e, dataSet: set) else { continue }

                let trans = chart.getTransformer(forAxis: set.axisDependency)

                context.setFillColor(set.highlightColor.cgColor)
                context.setAlpha(set.highlightAlpha)

                let isStack = high.stackIndex >= 0 && e.isStacked

                let y1: Double
                let y2: Double

                if isStack {
                    if chart.isHighlightFullBarEnabled {
                        y1 = e.positiveSum
                        y2 = -e.negativeSum
                    } else {
                        let range = e.ranges?[high.stackIndex]

                        y1 = range?.lowerBound ?? 0.0
                        y2 = range?.upperBound ?? 0.0
                    }
                } else {
                    y1 = e.y
                    y2 = 0.0
                }

                prepareBarHighlight(x: e.x, y1: y1, y2: y2, barWidthHalf: chart.barWidth / 2.0, trans: trans, rect: &barRect)

                setHighlightDrawPos(highlight: high, barRect: barRect)

                context.fill(barRect)
            }
        }
    }

    /// Sets the drawing position of the highlight object based on the riven bar-rect.
    private func setHighlightDrawPos(highlight high: Highlight, barRect: CGRect) {
        high.setDraw(x: barRect.midY, y: barRect.origin.x + barRect.size.width)
    }
}

// TODO: DUPLICATE FROM BarChartRenderer
extension HorizontalBarChartRenderer {
    /// Creates a nested array of empty subarrays each of which will be populated with NSUIAccessibilityElements.
    /// This is marked internal to support HorizontalBarChartRenderer as well.
    private func accessibilityCreateEmptyOrderedElements() -> [[NSUIAccessibilityElement]] {
        // Unlike Bubble & Line charts, here we use the maximum entry count to account for stacked bars
        guard let maxEntryCount = chart?.data.maxEntryCountSet?.count else { return [] }

        return Array(repeating: [NSUIAccessibilityElement](),
                     count: maxEntryCount)
    }

    /// Creates an NSUIAccessibleElement representing the smallest meaningful bar of the chart
    /// i.e. in case of a stacked chart, this returns each stack, not the combined bar.
    /// Note that it is marked internal to support subclass modification in the HorizontalBarChart.
    private func createAccessibleElement(
        withIndex idx: Int,
        container: BarChartView,
        dataSet: BarChartDataSet,
        dataSetIndex: Int,
        stackSize: Int,
        modifier: (NSUIAccessibilityElement) -> Void
    ) -> NSUIAccessibilityElement {
        let element = NSUIAccessibilityElement(accessibilityContainer: container)
        let xAxis = container.xAxis

        let e = dataSet[idx / stackSize]
        guard let chart = chart else { return element }

        // NOTE: The formatter can cause issues when the x-axis labels are consecutive ints.
        // i.e. due to the Double conversion, if there are more than one data set that are grouped,
        // there is the possibility of some labels being rounded up. A floor() might fix this, but seems to be a brute force solution.
        let label = xAxis.valueFormatter?.stringForValue(e.x, axis: xAxis) ?? "\(e.x)"

        var elementValueText = dataSet.valueFormatter.stringForValue(
            e.y,
            entry: e,
            dataSetIndex: dataSetIndex,
            viewPortHandler: viewPortHandler
        )

        if dataSet.isStacked, let vals = e.yValues {
            let labelCount = min(dataSet.colors.count, stackSize)

            let stackLabel: String?
            if !dataSet.stackLabels.isEmpty, labelCount > 0 {
                let labelIndex = idx % labelCount
                stackLabel = dataSet.stackLabels.indices.contains(labelIndex) ? dataSet.stackLabels[labelIndex] : nil
            } else {
                stackLabel = nil
            }

            // Handles empty array of yValues
            let yValue = vals.isEmpty ? 0.0 : vals[idx % vals.count]

            elementValueText = dataSet.valueFormatter.stringForValue(
                yValue,
                entry: e,
                dataSetIndex: dataSetIndex,
                viewPortHandler: viewPortHandler
            )

            if let stackLabel = stackLabel {
                elementValueText = stackLabel + " \(elementValueText)"
            } else {
                elementValueText = "\(elementValueText)"
            }
        }

        let dataSetCount = chart.data.count
        let doesContainMultipleDataSets = dataSetCount > 1

        element.accessibilityLabel = "\(doesContainMultipleDataSets ? (dataSet.label ?? "") + ", " : "") \(label): \(elementValueText)"

        modifier(element)

        return element
    }
}
