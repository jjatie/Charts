//
//  BarLineScatterCandleBubbleChartDataSet.swift
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

public class BarLineScatterCandleBubbleChartDataSet: ChartDataSet, BarLineScatterCandleBubbleChartDataSetProtocol
{
    // MARK: - Data functions and accessors

    // MARK: - Styling functions and accessors

    public var highlightColor = NSUIColor(red: 255.0 / 255.0, green: 187.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    public var highlightLineWidth = CGFloat(0.5)
    public var highlightLineDashPhase = CGFloat(0.0)
    public var highlightLineDashLengths: [CGFloat]?

    // MARK: - NSCopying

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! BarLineScatterCandleBubbleChartDataSet
        copy.highlightColor = highlightColor
        copy.highlightLineWidth = highlightLineWidth
        copy.highlightLineDashPhase = highlightLineDashPhase
        copy.highlightLineDashLengths = highlightLineDashLengths
        return copy
    }
}
