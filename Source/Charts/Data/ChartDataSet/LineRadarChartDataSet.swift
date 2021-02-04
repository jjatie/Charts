//
//  LineRadarChartDataSet.swift
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

public class LineRadarChartDataSet: LineScatterCandleRadarChartDataSet, LineRadarChartDataSetProtocol {
    // MARK: - Styling functions and accessors

    /// The object that is used for filling the area below the line.
    /// **default**: nil
    public var fill: Fill = ColorFill(color: .defaultDataSet)

    /// The alpha value that is used for filling the line surface,
    /// **default**: 0.33
    public var fillAlpha = CGFloat(0.33)

    /// line width of the chart (min = 0.0, max = 10)
    ///
    /// **default**: 1
    public var lineWidth: CGFloat {
        get { _lineWidth }
        set { _lineWidth = newValue.clamped(to: 0 ... 10) }
    }
    private var _lineWidth = CGFloat(1.0)

    public var isDrawFilledEnabled = false

    // MARK: NSCopying

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! LineRadarChartDataSet
        copy.fill = fill
        copy.fillAlpha = fillAlpha
        copy.fill = fill
        copy._lineWidth = _lineWidth
        copy.isDrawFilledEnabled = isDrawFilledEnabled
        return copy
    }
}
