//
//  ScatterChartView.swift
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

/// The ScatterChart. Draws dots, triangles, squares and custom shapes into the chartview.
public final class ScatterChartView: BarLineChartViewBase<ChartDataEntry> {
    override func initialize() {
        super.initialize()

        renderer = ScatterChartRenderer(chart: self, animator: chartAnimator, viewPortHandler: viewPortHandler)

        xAxis.spaceMin = 0.5
        xAxis.spaceMax = 0.5
    }
}
