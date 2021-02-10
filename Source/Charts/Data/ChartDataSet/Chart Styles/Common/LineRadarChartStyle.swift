import CoreGraphics

extension LineChartStyle {
    /// - Returns: The object that is used for filling the area below the line.
    /// **default**: ColorFill
    public var fill: Fill {
        get { self[FillChartStyleKey.self] }
        set { self[FillChartStyleKey.self] = newValue }
    }

    /// The alpha value that is used for filling the line surface.
    /// **default**: 0.33
    public var fillAlpha: CGFloat {
        get { self[FillAlphaChartStyleKey.self] }
        set { self[FillAlphaChartStyleKey.self] = newValue }
    }

    /// Set to `true` if the DataSet should be drawn filled (surface), and not just as a line.
    /// Disabling this will give great performance boost.
    /// Please note that this method uses the path clipping for drawing the filled area (with images, gradients and layers).
    public var isDrawFilledEnabled: Bool {
        get { self[FillToggleChartStyleKey.self] }
        set { self[FillToggleChartStyleKey.self] = newValue }
    }

    /// line width of the chart (min = 0.0, max = 10)
    ///
    /// **default**: 1
    public var lineWidth: CGFloat {
        get { self[LineWidthChartStyleKey.self] }
        set { self[LineWidthChartStyleKey.self] = newValue.clamped(to: 0 ... 10) }
    }
}

extension RadarChartStyle {
    /// - Returns: The object that is used for filling the area below the line.
    /// **default**: ColorFill
    public var fill: Fill {
        get { self[FillChartStyleKey.self] }
        set { self[FillChartStyleKey.self] = newValue }
    }

    /// The alpha value that is used for filling the line surface.
    /// **default**: 0.33
    public var fillAlpha: CGFloat {
        get { self[FillAlphaChartStyleKey.self] }
        set { self[FillAlphaChartStyleKey.self] = newValue }
    }

    /// Set to `true` if the DataSet should be drawn filled (surface), and not just as a line.
    /// Disabling this will give great performance boost.
    /// Please note that this method uses the path clipping for drawing the filled area (with images, gradients and layers).
    public var isDrawFilledEnabled: Bool {
        get { self[FillToggleChartStyleKey.self] }
        set { self[FillToggleChartStyleKey.self] = newValue }
    }

    /// line width of the chart (min = 0.0, max = 10)
    ///
    /// **default**: 1
    public var lineWidth: CGFloat {
        get { self[LineWidthChartStyleKey.self] }
        set { self[LineWidthChartStyleKey.self] = newValue.clamped(to: 0 ... 10) }
    }
}

// MARK: - Keys

private enum FillChartStyleKey: ChartStyleKey {
    static let defaultValue: Fill = ColorFill(color: .defaultDataSet)
}

private enum FillAlphaChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.33
}

private enum FillToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum LineWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 1
}
