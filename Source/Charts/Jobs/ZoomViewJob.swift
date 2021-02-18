//
//  ZoomViewJob.swift
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

open class ZoomViewJob<Entry: ChartDataEntry2D>: ViewPortJob {
    internal var scaleX: CGFloat = 0.0
    internal var scaleY: CGFloat = 0.0
    internal var axisDependency: YAxis.AxisDependency = .left

    public init(
        viewPortHandler: ViewPortHandler,
        scaleX: CGFloat,
        scaleY: CGFloat,
        xValue: Double,
        yValue: Double,
        transformer: Transformer,
        axis: YAxis.AxisDependency,
        view: BarLineChartViewBase<Entry>
    ) {
        self.scaleX = scaleX
        self.scaleY = scaleY
        axisDependency = axis

        super.init(
            viewPortHandler: viewPortHandler,
            xValue: xValue,
            yValue: yValue,
            transformer: transformer,
            view: view
        )
    }

    override open func doJob() {
        var matrix = viewPortHandler.setZoom(scaleX: scaleX, scaleY: scaleY)
        viewPortHandler.refresh(newMatrix: matrix, chart: view, invalidate: false)

        let view = self.view as! BarLineChartViewBase<Entry>
        let yValsInView = view.getAxis(axisDependency).axisRange / Double(viewPortHandler.scaleY)
        let xValsInView = view.xAxis.axisRange / Double(viewPortHandler.scaleX)

        var pt = CGPoint(
            x: CGFloat(xValue - xValsInView / 2.0),
            y: CGFloat(yValue + yValsInView / 2.0)
        )

        transformer.pointValueToPixel(&pt)

        matrix = viewPortHandler.translate(pt: pt)
        viewPortHandler.refresh(newMatrix: matrix, chart: view, invalidate: false)

        view.calculateOffsets()
        view.setNeedsDisplay()
    }
}
