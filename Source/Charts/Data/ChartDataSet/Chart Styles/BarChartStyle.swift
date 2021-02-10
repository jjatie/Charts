import CoreGraphics

typealias BarChartStyle = ChartStyle<BarChartDataEntry>

extension BarChartStyle {
    /// array of labels used to describe the different values of the stacked bars
    public var stackLabels: [String] {
        get { self[StackLabelsChartStyleKey.self] }
        set { self[StackLabelsChartStyleKey.self] = newValue }
    }

    /// the color used for drawing the bar-shadows. The bar shadows is a surface behind the bar that indicates the maximum value
    public var barShadowColor: NSUIColor {
        get { self[BarShadowColorChartStyleKey.self] }
        set { self[BarShadowColorChartStyleKey.self] = newValue }
    }

    /// the width used for drawing borders around the bars. If borderWidth == 0, no border will be drawn.
    public var barBorderWidth: CGFloat {
        get { self[BarBorderWidthChartStyleKey.self] }
        set { self[BarBorderWidthChartStyleKey.self] = newValue }
    }

    /// the color drawing borders around the bars.
    public var barBorderColor: NSUIColor {
        get { self[BarBorderColorChartStyleKey.self] }
        set { self[BarBorderColorChartStyleKey.self] = newValue }
    }

    /// the alpha value (transparency) that is used for drawing the highlight indicator bar. min = 0.0 (fully transparent), max = 1.0 (fully opaque)
    public var highlightAlpha: CGFloat {
        get { self[HighlightAlphaChartStyleKey.self] }
        set { self[HighlightAlphaChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum StackLabelsChartStyleKey: ChartStyleKey {
    static let defaultValue: [String] = []
}

private enum BarShadowColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor = NSUIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
}

private enum BarBorderWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0
}

private enum BarBorderColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor = .black
}

private enum HighlightAlphaChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 120 / 255
}
