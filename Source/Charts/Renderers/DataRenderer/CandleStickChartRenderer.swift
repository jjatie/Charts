//
//  CandleStickChartRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Algorithms
import CoreGraphics
import Foundation

public class CandleStickChartRenderer: DataRenderer {
    public let viewPortHandler: ViewPortHandler

    public final var accessibleChartElements: [NSUIAccessibilityElement] = []

    public let animator: Animator

    let xBounds = XBounds()

    open weak var chart: CandleStickChartView?

    public init(chart: CandleStickChartView, animator: Animator, viewPortHandler: ViewPortHandler)
    {
        self.viewPortHandler = viewPortHandler
        self.animator = animator
        self.chart = chart
    }

    public func drawData(context: CGContext) {
        guard let chart = chart else { return }
        let candleData = chart.data

        // If we redraw the data, remove and repopulate accessible elements to update label values and frames
        accessibleChartElements.removeAll()

        // Make the chart header the first element in the accessible elements array
        let element = createAccessibleHeader(
            usingChart: chart,
            andData: candleData,
            withDefaultDescription: "CandleStick Chart"
        )
        accessibleChartElements.append(element)

        for set in candleData where set.isVisible {
            drawDataSet(context: context, dataSet: set)
        }
    }

    private var _shadowPoints = [CGPoint](repeating: CGPoint(), count: 4)
    private var _rangePoints = [CGPoint](repeating: CGPoint(), count: 2)
    private var _openPoints = [CGPoint](repeating: CGPoint(), count: 2)
    private var _closePoints = [CGPoint](repeating: CGPoint(), count: 2)
    private var _bodyRect = CGRect()

    open func drawDataSet(context: CGContext, dataSet: CandleChartDataSet) {
        guard
            let chart = chart
        else { return }

        let trans = chart.getTransformer(forAxis: dataSet.axisDependency)

        let phaseY = animator.phaseY
        let barSpace = dataSet.barSpace
        let showCandleBar = dataSet.showCandleBar

        xBounds.set(chart: chart, dataSet: dataSet, animator: animator)

        context.saveGState()

        context.setLineWidth(dataSet.shadowWidth)

        for (j, e) in dataSet[xBounds].indexed() {
            let xPos = e.x

            let open = e.open
            let close = e.close
            let high = e.high
            let low = e.low

            let doesContainMultipleDataSets = chart.data.count > 1
            var accessibilityMovementDescription = "neutral"
            var accessibilityRect = CGRect(x: CGFloat(xPos) + 0.5 - barSpace,
                                           y: CGFloat(low * phaseY),
                                           width: (2 * barSpace) - 1.0,
                                           height: CGFloat(abs(high - low) * phaseY))
            trans.rectValueToPixel(&accessibilityRect)

            if showCandleBar {
                // calculate the shadow

                _shadowPoints[0].x = CGFloat(xPos)
                _shadowPoints[1].x = CGFloat(xPos)
                _shadowPoints[2].x = CGFloat(xPos)
                _shadowPoints[3].x = CGFloat(xPos)

                if open > close {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(open * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = CGFloat(close * phaseY)
                } else if open < close {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(close * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = CGFloat(open * phaseY)
                } else {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(open * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = _shadowPoints[1].y
                }

                trans.pointValuesToPixel(&_shadowPoints)

                // draw the shadows

                var shadowColor: NSUIColor!
                if dataSet.isShadowColorSameAsCandle {
                    if open > close {
                        shadowColor = dataSet.decreasingColor ?? dataSet.color(at: j)
                    } else if open < close {
                        shadowColor = dataSet.increasingColor ?? dataSet.color(at: j)
                    } else {
                        shadowColor = dataSet.neutralColor ?? dataSet.color(at: j)
                    }
                }

                if shadowColor === nil {
                    shadowColor = dataSet.shadowColor ?? dataSet.color(at: j)
                }

                context.setStrokeColor(shadowColor.cgColor)
                context.strokeLineSegments(between: _shadowPoints)

                // calculate the body

                _bodyRect.origin.x = CGFloat(xPos) - 0.5 + barSpace
                _bodyRect.origin.y = CGFloat(close * phaseY)
                _bodyRect.size.width = (CGFloat(xPos) + 0.5 - barSpace) - _bodyRect.origin.x
                _bodyRect.size.height = CGFloat(open * phaseY) - _bodyRect.origin.y

                trans.rectValueToPixel(&_bodyRect)

                // draw body differently for increasing and decreasing entry

                if open > close {
                    accessibilityMovementDescription = "decreasing"

                    let color = dataSet.decreasingColor ?? dataSet.color(at: j)

                    if dataSet.isDecreasingFilled {
                        context.setFillColor(color.cgColor)
                        context.fill(_bodyRect)
                    } else {
                        context.setStrokeColor(color.cgColor)
                        context.stroke(_bodyRect)
                    }
                } else if open < close {
                    accessibilityMovementDescription = "increasing"

                    let color = dataSet.increasingColor ?? dataSet.color(at: j)

                    if dataSet.isIncreasingFilled {
                        context.setFillColor(color.cgColor)
                        context.fill(_bodyRect)
                    } else {
                        context.setStrokeColor(color.cgColor)
                        context.stroke(_bodyRect)
                    }
                } else {
                    let color = dataSet.neutralColor ?? dataSet.color(at: j)

                    context.setStrokeColor(color.cgColor)
                    context.stroke(_bodyRect)
                }
            } else {
                _rangePoints[0].x = CGFloat(xPos)
                _rangePoints[0].y = CGFloat(high * phaseY)
                _rangePoints[1].x = CGFloat(xPos)
                _rangePoints[1].y = CGFloat(low * phaseY)

                _openPoints[0].x = CGFloat(xPos) - 0.5 + barSpace
                _openPoints[0].y = CGFloat(open * phaseY)
                _openPoints[1].x = CGFloat(xPos)
                _openPoints[1].y = CGFloat(open * phaseY)

                _closePoints[0].x = CGFloat(xPos) + 0.5 - barSpace
                _closePoints[0].y = CGFloat(close * phaseY)
                _closePoints[1].x = CGFloat(xPos)
                _closePoints[1].y = CGFloat(close * phaseY)

                trans.pointValuesToPixel(&_rangePoints)
                trans.pointValuesToPixel(&_openPoints)
                trans.pointValuesToPixel(&_closePoints)

                // draw the ranges
                var barColor: NSUIColor!

                if open > close {
                    accessibilityMovementDescription = "decreasing"
                    barColor = dataSet.decreasingColor ?? dataSet.color(at: j)
                } else if open < close {
                    accessibilityMovementDescription = "increasing"
                    barColor = dataSet.increasingColor ?? dataSet.color(at: j)
                } else {
                    barColor = dataSet.neutralColor ?? dataSet.color(at: j)
                }

                context.setStrokeColor(barColor.cgColor)
                context.strokeLineSegments(between: _rangePoints)
                context.strokeLineSegments(between: _openPoints)
                context.strokeLineSegments(between: _closePoints)
            }

            let axElement = createAccessibleElement(withIndex: j,
                                                    container: chart,
                                                    dataSet: dataSet) { element in
                element.accessibilityLabel = "\(doesContainMultipleDataSets ? "\(dataSet.label ?? "Dataset")" : "") " + "\(xPos) - \(accessibilityMovementDescription). low: \(low), high: \(high), opening: \(open), closing: \(close)"
                element.accessibilityFrame = accessibilityRect
            }

            accessibleChartElements.append(axElement)
        }

        // Post this notification to let VoiceOver account for the redrawn frames
        accessibilityPostLayoutChangedNotification()

        context.restoreGState()
    }

    public func drawValues(context: CGContext) {
        guard let chart = chart else { return }
        let candleData = chart.data

        // if values are drawn
        if isDrawingValuesAllowed(chart: chart) {
            let phaseY = animator.phaseY

            var pt = CGPoint()

            for (i, dataSet) in candleData.indexed() where shouldDrawValues(forDataSet: dataSet) {

                let valueFont = dataSet.valueFont

                let formatter = dataSet.valueFormatter

                let trans = chart.getTransformer(forAxis: dataSet.axisDependency)
                let valueToPixelMatrix = trans.valueToPixelMatrix

                let iconsOffset = dataSet.iconsOffset

                let angleRadians = dataSet.valueLabelAngle.DEG2RAD

                xBounds.set(chart: chart, dataSet: dataSet, animator: animator)

                let lineHeight = valueFont.lineHeight
                let yOffset: CGFloat = lineHeight + 5.0

                for (j, e) in dataSet[xBounds].indexed() {
                    pt.x = CGFloat(e.x)
                    pt.y = CGFloat(e.high * phaseY)
                    pt = pt.applying(valueToPixelMatrix)

                    if !viewPortHandler.isInBoundsRight(pt.x) {
                        break
                    }

                    if !viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y) {
                        continue
                    }

                    if dataSet.isDrawValuesEnabled {
                        context.drawText(formatter.stringForValue(e.high,
                                                                  entry: e,
                                                                  dataSetIndex: i,
                                                                  viewPortHandler: viewPortHandler),
                                         at: CGPoint(x: pt.x,
                                                     y: pt.y - yOffset),
                                         align: .center,
                                         angleRadians: angleRadians,
                                         attributes: [.font: valueFont,
                                                      .foregroundColor: dataSet.valueTextColorAt(j)])
                    }

                    if let icon = e.icon, dataSet.isDrawIconsEnabled {
                        context.drawImage(icon,
                                          atCenter: CGPoint(x: pt.x + iconsOffset.x,
                                                            y: pt.y + iconsOffset.y),
                                          size: icon.size)
                    }
                }
            }
        }
    }

    public func drawExtras(context _: CGContext) {}

    public func drawHighlighted(context: CGContext, indices: [Highlight]) {
        guard let chart = chart else { return }
        let candleData = chart.data

        context.saveGState()

        for high in indices {
            let set = candleData[high.dataSetIndex]
            guard set.isHighlightingEnabled,
                  let e = set.element(withX: high.x, closestToY: high.y),
                  isInBoundsX(entry: e, dataSet: set)
            else { continue }

            let trans = chart.getTransformer(forAxis: set.axisDependency)

            context.setStrokeColor(set.highlightColor.cgColor)
            context.setLineWidth(set.highlightLineWidth)

            if set.highlightLineDashLengths != nil {
                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
            } else {
                context.setLineDash(phase: 0.0, lengths: [])
            }

            let lowValue = e.low * Double(animator.phaseY)
            let highValue = e.high * Double(animator.phaseY)
            let y = (lowValue + highValue) / 2.0

            let pt = trans.pixelForValues(x: e.x, y: y)

            high.setDraw(pt: pt)

            // draw the lines
            drawHighlightLines(context: context, point: pt, set: set)
        }

        context.restoreGState()
    }

    private func createAccessibleElement(withIndex _: Int,
                                         container: CandleStickChartView,
                                         dataSet _: CandleChartDataSet,
                                         modifier: (NSUIAccessibilityElement) -> Void) -> NSUIAccessibilityElement
    {
        let element = NSUIAccessibilityElement(accessibilityContainer: container)

        // The modifier allows changing of traits and frame depending on highlight, rotation, etc
        modifier(element)

        return element
    }
}
