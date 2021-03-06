//
//  LineChartDataProvider.swift
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

public protocol LineChartDataProvider: BarLineScatterCandleBubbleChartDataProvider {
    var lineData: LineChartData? { get }

    /// The maximum x-value of the chart, regardless of zoom or translation.
    var chartXMax: Double { get }

    func getAxis(_ axis: YAxis.AxisDependency) -> YAxis
}
