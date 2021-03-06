//
//  LargeValueFormatter.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

import Charts
import Foundation

private let MAX_LENGTH = 5

protocol Testing123 {}

public class LargeValueFormatter: NSObject, ValueFormatter, AxisValueFormatter {
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    public var suffix = ["", "k", "m", "b", "t"]

    /// An appendix text to be added at the end of the formatted value.
    public var appendix: String?

    public init(appendix: String? = nil) {
        self.appendix = appendix
    }

    fileprivate func format(value: Double) -> String {
        var sig = value
        var length = 0
        let maxLength = suffix.count - 1

        while sig >= 1000.0, length < maxLength {
            sig /= 1000.0
            length += 1
        }

        var r = String(format: "%2.f", sig) + suffix[length]

        if let appendix = appendix {
            r += appendix
        }

        return r
    }

    public func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
        return format(value: value)
    }

    public func stringForValue(
        _ value: Double,
        entry _: ChartDataEntry,
        dataSetIndex _: Int,
        viewPortHandler _: ViewPortHandler?
    ) -> String {
        return format(value: value)
    }
}
