//
//  BubbleChartDataSet.swift
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

public class BubbleChartDataSet: BarLineScatterCandleBubbleChartDataSet, BubbleChartDataSetProtocol {
    // MARK: - Data functions and accessors

    public private(set) var maxSize: CGFloat = 0

    public private(set) var isNormalizeSizeEnabled: Bool = true

    override public func calcMinMax(entry e: ChartDataEntry) {
        guard let e = e as? BubbleChartDataEntry
        else { return }

        super.calcMinMax(entry: e)

        maxSize = Swift.max(e.size, maxSize)
    }

    // MARK: - Styling functions and accessors

    /// Sets/gets the width of the circle that surrounds the bubble when highlighted
    public var highlightCircleWidth: CGFloat = 2.5

    // MARK: - NSCopying

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! BubbleChartDataSet
        copy.maxSize = maxSize
        copy.isNormalizeSizeEnabled = isNormalizeSizeEnabled
        copy.highlightCircleWidth = highlightCircleWidth
        return copy
    }
}
