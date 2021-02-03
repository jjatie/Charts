//
//  ChartDataProvider.swift
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

public protocol ChartDataProvider: AnyObject {
    /// The minimum y-value of the chart, regardless of zoom or translation.
    var chartYMin: Double { get }

    /// The maximum y-value of the chart, regardless of zoom or translation.
    var chartYMax: Double { get }

    var maxHighlightDistance: CGFloat { get }

    var centerOffsets: CGPoint { get }

    var data: ChartData<ChartDataEntry>? { get }

    var maxVisibleCount: Int { get }
}
