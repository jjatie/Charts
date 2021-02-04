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
        _ dataProvider: LineChartDataProvider
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
        dataProvider: LineChartDataProvider
    ) -> CGFloat {
        guard block == nil else { return block!(dataSet, dataProvider) }
        var fillMin: CGFloat = 0.0

        if dataSet.yMax > 0.0, dataSet.yMin < 0.0 {
            fillMin = 0.0
        } else if let data = dataProvider.data {
            let max = data.yMax > 0.0 ? 0.0 : dataProvider.chartYMax
            let min = data.yMin < 0.0 ? 0.0 : dataProvider.chartYMin

            fillMin = CGFloat(dataSet.yMin >= 0.0 ? min : max)
        }

        return fillMin
    }
}
