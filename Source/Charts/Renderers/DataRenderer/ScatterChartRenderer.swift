//
//  ScatterChartRenderer.swift
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

public class ScatterChartRenderer: DataRenderer {
    public let viewPortHandler: ViewPortHandler

    public final var accessibleChartElements: [NSUIAccessibilityElement] = []

    public let animator: Animator

    let xBounds = XBounds()

    open weak var chart: ScatterChartView?

    public init(chart: ScatterChartView, animator: Animator, viewPortHandler: ViewPortHandler)
    {
        self.viewPortHandler = viewPortHandler
        self.animator = animator
        self.chart = chart
    }

    public func drawData(context: CGContext) {
        guard let scatterData = chart?.data else { return }

        // If we redraw the data, remove and repopulate accessible elements to update label values and frames
        accessibleChartElements.removeAll()

        if let chart = chart {
            // Make the chart header the first element in the accessible elements array
            let element = createAccessibleHeader(usingChart: chart,
                                                 andData: scatterData,
                                                 withDefaultDescription: "Scatter Chart")
            accessibleChartElements.append(element)
        }

        // TODO: Due to the potential complexity of data presented in Scatter charts, a more usable way
        // for VO accessibility would be to use axis based traversal rather than by dataset.
        // Hence, accessibleChartElements is not populated below. (Individual renderers guard against dataSource being their respective views)

        // TODO
        let drawDataSet = { self.drawDataSet(context: context, dataSet: $0) }
        scatterData.lazy
            .filter(\.isVisible)
            .forEach(drawDataSet)
    }

    public func drawDataSet(context: CGContext, dataSet: ScatterChartDataSet) {
        guard let chart = chart else { return }

        let trans = chart.getTransformer(forAxis: dataSet.axisDependency)

        let phaseY = animator.phaseY

        let entryCount = dataSet.count

        var point = CGPoint()

        let valueToPixelMatrix = trans.valueToPixelMatrix

        if let renderer = dataSet.shapeRenderer {
            context.saveGState()

            for j in 0 ..< Int(min(ceil(Double(entryCount) * animator.phaseX), Double(entryCount)))
            {
                let e = dataSet[j]

                point.x = CGFloat(e.x)
                point.y = CGFloat(e.y * phaseY)
                point = point.applying(valueToPixelMatrix)

                if !viewPortHandler.isInBoundsRight(point.x) {
                    break
                }

                if !viewPortHandler.isInBoundsLeft(point.x) ||
                    !viewPortHandler.isInBoundsY(point.y)
                {
                    continue
                }

                renderer.renderShape(context: context, dataSet: dataSet, viewPortHandler: viewPortHandler, point: point, color: dataSet.color(at: j))
            }

            context.restoreGState()
        } else {
            print("There's no ShapeRenderer specified for ScatterDataSet", terminator: "\n")
        }
    }

    public func drawValues(context: CGContext) {
        guard let chart = chart,
              isDrawingValuesAllowed(chart: chart)
        else { return }
        let scatterData = chart.data

        // if values are drawn
        let phaseY = animator.phaseY

        var pt = CGPoint()

        for (i, dataSet) in scatterData.indexed() where shouldDrawValues(forDataSet: dataSet) {
            let valueFont = dataSet.valueFont

            let formatter = dataSet.valueFormatter

            let trans = chart.getTransformer(forAxis: dataSet.axisDependency)
            let valueToPixelMatrix = trans.valueToPixelMatrix

            let iconsOffset = dataSet.iconsOffset

            let angleRadians = dataSet.valueLabelAngle.DEG2RAD

            let shapeSize = dataSet.scatterShapeSize
            let lineHeight = valueFont.lineHeight

            xBounds.set(chart: chart, dataSet: dataSet, animator: animator)

            for (j, e) in dataSet[xBounds].indexed() {
                pt.x = CGFloat(e.x)
                pt.y = CGFloat(e.y * phaseY)
                pt = pt.applying(valueToPixelMatrix)

                if !viewPortHandler.isInBoundsRight(pt.x) {
                    break
                }

                // make sure the lines don't do shitty things outside bounds
                if !viewPortHandler.isInBoundsLeft(pt.x)
                    || !viewPortHandler.isInBoundsY(pt.y)
                {
                    continue
                }

                let text = formatter.stringForValue(
                    e.y,
                    entry: e,
                    dataSetIndex: i,
                    viewPortHandler: viewPortHandler
                )

                if dataSet.isDrawValuesEnabled {
                    context.drawText(text,
                                     at: CGPoint(x: pt.x,
                                                 y: pt.y - shapeSize - lineHeight),
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

    public func drawExtras(context _: CGContext) {}

    public func drawHighlighted(context: CGContext, indices: [Highlight]) {
        guard let chart = chart else { return }
        let scatterData = chart.data

        context.saveGState()

        for high in indices {
            let set = scatterData[high.dataSetIndex]
            guard set.isHighlightingEnabled,
                  let entry = set.element(withX: high.x, closestToY: high.y),
                  isInBoundsX(entry: entry, dataSet: set)
            else {
                continue
            }

            context.setStrokeColor(set.highlightColor.cgColor)
            context.setLineWidth(set.highlightLineWidth)
            if set.highlightLineDashLengths != nil {
                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
            } else {
                context.setLineDash(phase: 0.0, lengths: [])
            }

            let x = entry.x // get the x-position
            let y = entry.y * Double(animator.phaseY)

            let trans = chart.getTransformer(forAxis: set.axisDependency)

            let pt = trans.pixelForValues(x: x, y: y)

            high.setDraw(pt: pt)

            // draw the lines
            drawHighlightLines(context: context, point: pt, set: set)
        }

        context.restoreGState()
    }
}
