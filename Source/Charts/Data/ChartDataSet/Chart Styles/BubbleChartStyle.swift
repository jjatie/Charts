import CoreGraphics

typealias BubbleChartStyle = ChartStyle<BubbleChartDataEntry>

extension BubbleChartStyle {
    public internal(set) var maxSize: CGFloat {
        get { self[MaxSizeChartStyleKey.self] }
        set { self[MaxSizeChartStyleKey.self] = newValue }
    }

    public internal(set) var isNormalizeSizeEnabled: Bool {
        get { self[NormalizeSizeToggleChartStyleKey.self] }
        set { self[NormalizeSizeToggleChartStyleKey.self] = newValue }
    }

    /// Sets/gets the width of the circle that surrounds the bubble when highlighted
    public var highlightCircleWidth: CGFloat {
        get { self[MaxSizeChartStyleKey.self] }
        set { self[MaxSizeChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum MaxSizeChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0
}

private enum NormalizeSizeToggleChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum HighlightCircleWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 2.5
}
