//
//  BubbleChartView.swift
//  Charts
//
//  Bubble chart implementation:
//    Copyright 2015 Pierre-Marc Airoldi
//    Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import CoreGraphics
import Foundation

public final class BubbleChartView: BarLineChartViewBase<BubbleChartDataEntry> {
    override public final func initialize() {
        super.initialize()

        renderer = BubbleChartRenderer(chart: self, animator: chartAnimator, viewPortHandler: viewPortHandler)
    }
}
