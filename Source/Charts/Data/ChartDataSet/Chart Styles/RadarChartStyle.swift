import CoreGraphics

typealias RadarChartStyle = ChartStyle<RadarChartDataEntry>

extension RadarChartStyle {
    public var highlightLineWidth: CGFloat {
        get { self[HighlightLineWidthChartStyleKey.self] }
        set { self[HighlightLineWidthChartStyleKey.self] = newValue}
    }

    /// flag indicating whether highlight circle should be drawn or not
    /// **default**: false
    public var isDrawHighlightCircleEnabled: Bool {
        get { self[DrawHighlightCircleToggleChartStyleKey.self] }
        set { self[DrawHighlightCircleToggleChartStyleKey.self] = newValue}
    }

    public var highlightCircleFillColor: NSUIColor? {
        get { self[HighlightCircleFillColorChartStyleKey.self] }
        set { self[HighlightCircleFillColorChartStyleKey.self] = newValue}
    }

    /// The stroke color for highlight circle.
    /// If `nil`, the color of the dataset is taken.
    public var highlightCircleStrokeColor: NSUIColor? {
        get { self[HighlightCircleStrokeColorChartStyleKey.self] }
        set { self[HighlightCircleStrokeColorChartStyleKey.self] = newValue}
    }

    public var highlightCircleStrokeAlpha: CGFloat {
        get { self[HighlightCircleStrokeAlphaChartStyleKey.self] }
        set { self[HighlightCircleStrokeAlphaChartStyleKey.self] = newValue}
    }

    public var highlightCircleStrokeWidth: CGFloat {
        get { self[HighlightCircleStrokeWidthChartStyleKey.self] }
        set { self[HighlightCircleStrokeWidthChartStyleKey.self] = newValue}
    }

    public var highlightCircleInnerRadius: CGFloat {
        get { self[HighlightCircleInnerRadiusChartStyleKey.self] }
        set { self[HighlightCircleInnerRadiusChartStyleKey.self] = newValue}
    }

    public var highlightCircleOuterRadius: CGFloat {
        get { self[HighlightCircleOuterRadiusChartStyleKey.self] }
        set { self[HighlightCircleOuterRadiusChartStyleKey.self] = newValue}
    }
}

private enum HighlightLineWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 1
}

private enum DrawHighlightCircleToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = false
}

private enum HighlightCircleFillColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = .white
}

private enum HighlightCircleStrokeColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = nil
}

private enum HighlightCircleStrokeAlphaChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.3
}

private enum HighlightCircleStrokeWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 2
}

private enum HighlightCircleInnerRadiusChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 3
}

private enum HighlightCircleOuterRadiusChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 4
}
