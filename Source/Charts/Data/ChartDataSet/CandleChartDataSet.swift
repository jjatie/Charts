//
//  CandleChartDataSet.swift
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

public class CandleChartDataSet: LineScatterCandleRadarChartDataSet, CandleChartDataSetProtocol {
    public required init() {
        super.init()
    }

    override public init(entries: [ChartDataEntry], label: String) {
        super.init(entries: entries, label: label)
    }

    // MARK: - Data functions and accessors

    override public func calcMinMax(entry e: ChartDataEntry) {
        guard let e = e as? CandleChartDataEntry
        else { return }

        yMin = Swift.min(e.low, yMin)
        yMax = Swift.max(e.high, yMax)

        calcMinMaxX(entry: e)
    }

    override public func calcMinMaxY(entry e: ChartDataEntry) {
        guard let e = e as? CandleChartDataEntry
        else { return }

        yMin = Swift.min(e.low, yMin)
        yMax = Swift.max(e.high, yMin)

        yMin = Swift.min(e.low, yMax)
        yMax = Swift.max(e.high, yMax)
    }

    // MARK: - Styling functions and accessors

    /// the space between the candle entries
    ///
    /// **default**: 0.1 (10%)
    private var _barSpace: CGFloat = 0.1

    /// the space that is left out on the left and right side of each candle,
    /// **default**: 0.1 (10%), max 0.45, min 0.0
    public var barSpace: CGFloat {
        get { _barSpace }
        set {
            _barSpace = newValue.clamped(to: 0 ... 0.45)
        }
    }

    /// should the candle bars show?
    /// when false, only "ticks" will show
    ///
    /// **default**: true
    public var showCandleBar = true

    /// the width of the candle-shadow-line in pixels.
    ///
    /// **default**: 1.5
    public var shadowWidth: CGFloat = 1.5

    /// the color of the shadow line
    public var shadowColor: NSUIColor?

    public var isShadowColorSameAsCandle = false

    /// color for open == close
    public var neutralColor: NSUIColor?

    /// color for open > close
    public var increasingColor: NSUIColor?

    /// color for open < close
    public var decreasingColor: NSUIColor?

    public var isIncreasingFilled = false

    public var isDecreasingFilled = true
}
