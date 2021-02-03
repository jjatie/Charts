import CoreGraphics

public typealias LineChartStyle = ChartStyle<ChartDataEntry>

extension LineChartStyle {
    public enum Mode {
        case linear
        case stepped
        case cubicBezier
        case horizontalBezier
    }

    /// The drawing mode for this line dataset
    ///
    /// **default**: .linear
    public var mode: Mode {
        get { self[ModeChartStyleKey.self] }
        set { self[ModeChartStyleKey.self] = newValue }
    }

    /// Intensity for cubic lines (min = 0.05, max = 1)
    ///
    /// **default**: 0.2
    public var cubicIntensity: CGFloat {
        get { self[CubicIntensityChartStyleKey.self] }
        set { self[CubicIntensityChartStyleKey.self] = newValue.clamped(to: 0.05 ... 1) }
    }

    /// If true, gradient lines are drawn instead of solid
    public var isDrawLineWithGradientEnabled: Bool {
        get { self[DrawLineWithGradientToggleChartStyleKey.self] }
        set { self[DrawLineWithGradientToggleChartStyleKey.self] = newValue }
    }

    /// The points where gradient should change color
    public var gradientPositions: [CGFloat]? {
        get { self[GradientPositionsChartStyleKey.self] }
        set { self[GradientPositionsChartStyleKey.self] = newValue }
    }

    /// If true, drawing circles is enabled
    public var isDrawCirclesEnabled: Bool {
        get { self[DrawCirclesToggleChartStyleKey.self] }
        set { self[DrawCirclesToggleChartStyleKey.self] = newValue }
    }

    /// `true` if drawing circles for this DataSet is enabled, `false` ifnot
    public var isDrawCircleHoleEnabled: Bool {
        get { self[DrawCircleHoleToggleChartStyleKey.self] }
        set { self[DrawCircleHoleToggleChartStyleKey.self] = newValue }
    }

    /// The radius of the drawn circles.
    public var circleRadius: CGFloat {
        get { self[CircleRadiusChartStyleKey.self] }
        set { self[CircleRadiusChartStyleKey.self] = newValue }
    }

    /// The hole radius of the drawn circles
    public var circleHoleRadius: CGFloat {
        get { self[CircleHoleRadiusChartStyleKey.self] }
        set { self[CircleHoleRadiusChartStyleKey.self] = newValue }
    }

    /// The color of the inner circle (the circle-hole).
    public var circleHoleColor: NSUIColor? {
        get { self[CircleHoleColorChartStyleKey.self] }
        set { self[CircleHoleColorChartStyleKey.self] = newValue }
    }

    public var circleColors: [NSUIColor] {
        get { self[CircleColorsChartStyleKey.self] }
        set { self[CircleColorsChartStyleKey.self] = newValue }
    }

    /// This is how much (in pixels) into the dash pattern are we starting from.
    public var lineDashPhase: CGFloat {
        get { self[LineDashPhaseChartStyleKey.self] }
        set { self[LineDashPhaseChartStyleKey.self] = newValue }
    }

    /// This is the actual dash pattern.
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    public var lineDashLengths: [CGFloat]? {
        get { self[LineDashLengthsChartStyleKey.self] }
        set { self[LineDashLengthsChartStyleKey.self] = newValue }
    }

    /// Line cap type, default is CGLineCap.Butt
    public var lineCapType: CGLineCap {
        get { self[LineCapChartStyleKey.self] }
        set { self[LineCapChartStyleKey.self] = newValue }
    }

    /// formatter for customizing the position of the fill-line

    /// Sets a custom FillFormatterProtocol to the chart that handles the position of the filled-line for each DataSet. Set this to null to use the default logic.
    public var fillFormatter: FillFormatter {
        get { self[FillFormatterChartStyleKey.self] }
        set { self[FillFormatterChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum ModeChartStyleKey: ChartStyleKey {
    static let defaultValue: LineChartStyle.Mode = .linear
}

// TODO: Make part of `Mode.cubicBezier`
private enum CubicIntensityChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.2
}

// TODO: Make gradient line drawing part of a new `LineRenderer` type
private enum DrawLineWithGradientToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = false
}

private enum GradientPositionsChartStyleKey: ChartStyleKey {
    static let defaultValue: [CGFloat]? = nil
}

private enum DrawCirclesToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum DrawCircleHoleToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum CircleRadiusChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 8
}

private enum CircleHoleRadiusChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 4
}

private enum CircleHoleColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = .white
}

private enum CircleColorsChartStyleKey: ChartStyleKey {
    static let defaultValue: [NSUIColor] = [.defaultDataSet]
}

private enum LineDashPhaseChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0
}

private enum LineDashLengthsChartStyleKey: ChartStyleKey {
    static let defaultValue: [CGFloat]? = nil
}

private enum LineCapChartStyleKey: ChartStyleKey {
    static let defaultValue: CGLineCap = .butt
}

private enum FillFormatterChartStyleKey: ChartStyleKey {
    static let defaultValue: FillFormatter = DefaultFillFormatter()
}
