extension LineChartStyle /*ScatterChartStyle*/ {
    /// Enables / disables the horizontal highlight-indicator. If disabled, the indicator is not drawn.
    public var isHorizontalHighlightIndicatorEnabled: Bool {
        get { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables the vertical highlight-indicator. If disabled, the indicator is not drawn.
    public var isVerticalHighlightIndicatorEnabled: Bool {
        get { self[VerticalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[VerticalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables both vertical and horizontal highlight-indicators.
    /// :param: enabled
//    public func setDrawHighlightIndicators(_ enabled: Bool) {
//        isHorizontalHighlightIndicatorEnabled = enabled
//        isVerticalHighlightIndicatorEnabled = enabled
//    }
}

extension CandleChartStyle {
    /// Enables / disables the horizontal highlight-indicator. If disabled, the indicator is not drawn.
    public var isHorizontalHighlightIndicatorEnabled: Bool {
        get { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables the vertical highlight-indicator. If disabled, the indicator is not drawn.
    public var isVerticalHighlightIndicatorEnabled: Bool {
        get { self[VerticalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[VerticalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables both vertical and horizontal highlight-indicators.
    /// :param: enabled
//    public func setDrawHighlightIndicators(_ enabled: Bool) {
//        isHorizontalHighlightIndicatorEnabled = enabled
//        isVerticalHighlightIndicatorEnabled = enabled
//    }
}

extension RadarChartStyle {
    /// Enables / disables the horizontal highlight-indicator. If disabled, the indicator is not drawn.
    public var isHorizontalHighlightIndicatorEnabled: Bool {
        get { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables the vertical highlight-indicator. If disabled, the indicator is not drawn.
    public var isVerticalHighlightIndicatorEnabled: Bool {
        get { self[VerticalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[VerticalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables both vertical and horizontal highlight-indicators.
    /// :param: enabled
//    public func setDrawHighlightIndicators(_ enabled: Bool) {
//        isHorizontalHighlightIndicatorEnabled = enabled
//        isVerticalHighlightIndicatorEnabled = enabled
//    }
}

// TODO: Remove need for top level properties
extension ChartStyle {
    /// Enables / disables the horizontal highlight-indicator. If disabled, the indicator is not drawn.
    public var isHorizontalHighlightIndicatorEnabled: Bool {
        get { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[HorizontalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables the vertical highlight-indicator. If disabled, the indicator is not drawn.
    public var isVerticalHighlightIndicatorEnabled: Bool {
        get { self[VerticalHighlightIndicatorToggleChartStyleKey.self] }
        set { self[VerticalHighlightIndicatorToggleChartStyleKey.self] = newValue}
    }

    /// Enables / disables both vertical and horizontal highlight-indicators.
    /// :param: enabled
//    public func setDrawHighlightIndicators(_ enabled: Bool) {
//        isHorizontalHighlightIndicatorEnabled = enabled
//        isVerticalHighlightIndicatorEnabled = enabled
//    }
}

// MARK: - Keys

private enum HorizontalHighlightIndicatorToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum VerticalHighlightIndicatorToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

