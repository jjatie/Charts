import CoreGraphics

extension ChartStyle {
    /// Set this to true to draw y-values on the chart.
    ///
    /// - Note: For bar and line charts: if `maxVisibleCount` is reached, no values will be drawn even if this is enabled.
    public var isDrawValuesEnabled: Bool {
        get { self[DrawValuesToggleChartStyleKey.self] }
        set { self[DrawValuesToggleChartStyleKey.self] = newValue }
    }

    /// List representing all colors that are used for drawing the actual values for this DataSet
    public var valueColors: [NSUIColor] {
        get { self[ValueColorsChartStyleKey.self] }
        set { self[ValueColorsChartStyleKey.self] = newValue }
    }

    /// Sets/get a single color for value text.
    /// Setting the color clears the colors array and adds a single color.
    /// Getting will return the first color in the array.
    // TODO: Revaluate if this is needed
    public var valueTextColor: NSUIColor {
        get { valueColors.first! }
        set { valueColors = [newValue] }
    }

    /// the font for the value-text labels
    public var valueFont: NSUIFont {
        get { self[ValueFontChartStyleKey.self] }
        set { self[ValueFontChartStyleKey.self] = newValue }
    }

    /// Custom formatter that is used instead of the auto-formatter if set
    public var valueFormatter: ValueFormatter {
        get { self[ValueFormatterChartStyleKey.self] }
        set { self[ValueFormatterChartStyleKey.self] = newValue }
    }

    /// The rotation angle (in degrees) for value-text labels
    public var valueLabelAngle: CGFloat {
        get { self[ValueLabelAngleChartStyleKey.self] }
        set { self[ValueLabelAngleChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum DrawValuesToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum ValueColorsChartStyleKey: ChartStyleKey {
    static let defaultValue: [NSUIColor] = [.labelOrBlack]
}

private enum ValueFontChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIFont = .systemFont(ofSize: 7)
}

private enum ValueFormatterChartStyleKey: ChartStyleKey {
    static let defaultValue: ValueFormatter = DefaultValueFormatter()
}

private enum ValueLabelAngleChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0
}
