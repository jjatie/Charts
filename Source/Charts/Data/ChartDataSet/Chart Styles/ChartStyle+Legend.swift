import CoreGraphics

extension ChartStyle {
    /// The form to draw for this dataset in the legend.
    public var form: Legend.Form {
        get { self[LegendFormChartStyleKey.self] }
        set { self[LegendFormChartStyleKey.self] = newValue }
    }

    /// The form size to draw for this dataset in the legend.
    ///
    /// Return `NaN` to use the default legend form size.
    public var formSize: CGFloat {
        get { self[LegendFormSizeChartStyleKey.self] }
        set { self[LegendFormSizeChartStyleKey.self] = newValue }
    }

    /// The line width for drawing the form of this dataset in the legend
    ///
    /// Return `NaN` to use the default legend form line width.
    public var formLineWidth: CGFloat {
        get { self[LegendFormLineWidthChartStyleKey.self] }
        set { self[LegendFormLineWidthChartStyleKey.self] = newValue }
    }

    /// Line dash configuration for legend shapes that consist of lines.
    ///
    /// This is how much (in pixels) into the dash pattern are we starting from.
    public var formLineDashPhase: CGFloat {
        get { self[LegendFormLineDashPhaseChartStyleKey.self] }
        set { self[LegendFormLineDashPhaseChartStyleKey.self] = newValue }
    }

    /// Line dash configuration for legend shapes that consist of lines.
    ///
    /// This is the actual dash pattern.
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    public var formLineDashLengths: [CGFloat]? {
        get { self[LegendFormLineDashLengthsChartStyleKey.self] }
        set { self[LegendFormLineDashLengthsChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum LegendFormChartStyleKey: ChartStyleKey {
    static let defaultValue: Legend.Form = .default
}

private enum LegendFormSizeChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = .nan
}

private enum LegendFormLineWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = .nan
}

private enum LegendFormLineDashPhaseChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.0
}

private enum LegendFormLineDashLengthsChartStyleKey: ChartStyleKey {
    static let defaultValue: [CGFloat]? = nil
}
