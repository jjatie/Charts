//
//  CandleStickChartView.swift
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

/// Financial chart type that draws candle-sticks.
public final class CandleStickChartView: BarLineChartViewBase<CandleChartDataEntry> {
    override func initialize() {
        super.initialize()

        renderer = CandleStickChartRenderer(chart: self, animator: chartAnimator, viewPortHandler: viewPortHandler)

        xAxis.spaceMin = 0.5
        xAxis.spaceMax = 0.5
    }
}
