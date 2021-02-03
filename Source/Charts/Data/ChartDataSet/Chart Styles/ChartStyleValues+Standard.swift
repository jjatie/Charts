import CoreGraphics

extension ChartStyleValues {
    /// `true` if this DataSet is visible inside the chart, or `false` ifit is currently hidden.
    public var isVisible: Bool {
        get { self[IsVisibleChartStyleKey.self] }
        set { self[IsVisibleChartStyleKey.self] = newValue }
    }

    /// All the colors that are used for this DataSet.
    /// Colors are reused as soon as the number of Entries the DataSet represents is higher than the size of the colors array.
    public var colors: [NSUIColor] {
        get { self[ColorsChartStyleKey.self] }
        set { self[ColorsChartStyleKey.self] = newValue }
    }

    /// if true, value highlighting is enabled
    public var isHighlightingEnabled: Bool {
        get { self[HighlightToggleChartStyleKey.self] }
        set { self[HighlightToggleChartStyleKey.self] = newValue }
    }

    /// Set this to true to draw y-icons on the chart
    ///
    /// - Note: For bar and line charts: if `maxVisibleCount` is reached, no icons will be drawn even if this is enabled.
    public var isDrawIconsEnabled: Bool {
        get { self[DrawIconsToggleChartStyleKey.self] }
        set { self[DrawIconsToggleChartStyleKey.self] = newValue }
    }

    /// Offset of icons drawn on the chart.
    ///
    /// - NOTE: For all charts except Pie and Radar it will be ordinary (x offset, y offset).
    ///
    /// For Pie and Radar chart it will be (y offset, distance from center offset); so if you want icon to be rendered under value, you should increase X component of CGPoint, and if you want icon to be rendered closet to center, you should decrease height component of CGPoint.
    public var iconsOffset: CGPoint {
        get { self[IconsOffsetChartStyleKey.self] }
        set { self[IconsOffsetChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum IsVisibleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum ColorsChartStyleKey: ChartStyleKey {
    static let defaultValue: [NSUIColor] = [.defaultDataSet]
}

private enum HighlightToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum DrawIconsToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum IconsOffsetChartStyleKey: ChartStyleKey {
    static let defaultValue: CGPoint = .zero
}
