//
//  LineScatterCandleRadarChartDataSet.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

public class LineScatterCandleRadarChartDataSet: BarLineScatterCandleBubbleChartDataSet, LineScatterCandleRadarChartDataSetProtocol
{
    // MARK: - Data functions and accessors

    // MARK: - Styling functions and accessors

    /// Enables / disables the horizontal highlight-indicator. If disabled, the indicator is not drawn.
    public var isHorizontalHighlightIndicatorEnabled = true

    /// Enables / disables the vertical highlight-indicator. If disabled, the indicator is not drawn.
    public var isVerticalHighlightIndicatorEnabled = true

    /// Enables / disables both vertical and horizontal highlight-indicators.
    /// :param: enabled
    public func setDrawHighlightIndicators(_ enabled: Bool) {
        isHorizontalHighlightIndicatorEnabled = enabled
        isVerticalHighlightIndicatorEnabled = enabled
    }

    // MARK: NSCopying

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! LineScatterCandleRadarChartDataSet
        copy.isHorizontalHighlightIndicatorEnabled = isHorizontalHighlightIndicatorEnabled
        copy.isVerticalHighlightIndicatorEnabled = isVerticalHighlightIndicatorEnabled
        return copy
    }
}
