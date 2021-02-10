//
//  DefaultFillFormatter.swift
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

/// Default formatter that calculates the position of the filled line.
open class DefaultFillFormatter: FillFormatter {
    public typealias Block = (
        _ dataSet: LineChartDataSet,
        _ chart: LineChartView
    ) -> CGFloat

    open var block: Block?

    public init() {}

    public init(block: @escaping Block) {
        self.block = block
    }

    public static func with(block: @escaping Block) -> DefaultFillFormatter? {
        return DefaultFillFormatter(block: block)
    }

    open func getFillLinePosition(
        dataSet: LineChartDataSet,
        chart: LineChartView
    ) -> CGFloat {
        guard block == nil else { return block!(dataSet, chart) }
        var fillMin: CGFloat = 0.0

        if dataSet.yRange.max > 0.0, dataSet.yRange.max < 0.0 {
            fillMin = 0.0
        } else {
            let max = chart.data.yRange.max > 0.0 ? 0.0 : chart.chartYMax
            let min = chart.data.yRange.min < 0.0 ? 0.0 : chart.chartYMin

            fillMin = CGFloat(dataSet.yRange.min >= 0.0 ? min : max)
        }

        return fillMin
    }
}
