import CoreGraphics

public typealias CandleChartStyle = ChartStyle<CandleChartDataEntry>

extension CandleChartStyle {
    /// the space that is left out on the left and right side of each candle,
    /// **default**: 0.1 (10%), max 0.45, min 0.0
    public var barSpace: CGFloat {
        get { self[BarSpaceChartStyleKey.self] }
        set { self[BarSpaceChartStyleKey.self] = newValue.clamped(to: 0 ... 0.45) }
    }

    /// should the candle bars show?
    /// when false, only "ticks" will show
    ///
    /// **default**: true
    public var showCandleBar: Bool {
        get { self[ShowCandleBarToggleChartStyleKey.self] }
        set { self[ShowCandleBarToggleChartStyleKey.self] = newValue }
    }

    public var isShadowColorSameAsCandle: Bool {
        get { self[ShadowColorSameAsCandleToggleChartStyleKey.self] }
        set { self[ShadowColorSameAsCandleToggleChartStyleKey.self] = newValue }
    }

    /// the width of the candle-shadow-line in pixels.
    ///
    /// **default**: 1.5
    public var shadowWidth: CGFloat {
        get { self[ShadowWidthChartStyleKey.self] }
        set { self[ShadowWidthChartStyleKey.self] = newValue }
    }

    /// the color of the shadow line
    public var shadowColor: NSUIColor? {
        get { self[ShadowColorChartStyleKey.self] }
        set { self[ShadowColorChartStyleKey.self] = newValue }
    }

    /// color for open == close
    public var neutralColor: NSUIColor? {
        get { self[NeutralColorChartStyleKey.self] }
        set { self[NeutralColorChartStyleKey.self] = newValue }
    }

    /// color for open > close
    public var increasingColor: NSUIColor? {
        get { self[IncreasingColorChartStyleKey.self] }
        set { self[IncreasingColorChartStyleKey.self] = newValue }
    }

    /// color for open < close
    public var decreasingColor: NSUIColor? {
        get { self[DecreasingColorChartStyleKey.self] }
        set { self[DecreasingColorChartStyleKey.self] = newValue }
    }

    /// Are increasing values drawn as filled?
    public var isIncreasingFilled: Bool {
        get { self[IncreasingFilledToggleChartStyleKey.self] }
        set { self[IncreasingFilledToggleChartStyleKey.self] = newValue }
    }

    /// Are decreasing values drawn as filled?
    public var isDecreasingFilled: Bool {
        get { self[DecreasingFilledToggleChartStyleKey.self] }
        set { self[DecreasingFilledToggleChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum BarSpaceChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.1
}

private enum ShowCandleBarToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum ShadowColorSameAsCandleToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = false
}

private enum ShadowWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 1.5
}

private enum ShadowColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = nil
}

private enum NeutralColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = nil
}

private enum IncreasingColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = nil
}

private enum DecreasingColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = nil
}

private enum IncreasingFilledToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = false
}

private enum DecreasingFilledToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}
