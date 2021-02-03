import CoreGraphics

extension BarChartStyle {
    public var highlightLineWidth: CGFloat {
        get { self[HighlightLineWidthChartStyleKey.self] }
        set { self[HighlightLineWidthChartStyleKey.self] = newValue}
    }

    public var highlightLineDashPhase: CGFloat {
        get { self[HighlightLineDashPhaseChartStyleKey.self] }
        set { self[HighlightLineDashPhaseChartStyleKey.self] = newValue}
    }

    public var highlightLineDashLengths: [CGFloat]? {
        get { self[HighlightLineDashLengthsChartStyleKey.self] }
        set { self[HighlightLineDashLengthsChartStyleKey.self] = newValue}
    }
}

extension LineChartStyle /*ScatterChartStyle*/{
    public var highlightLineWidth: CGFloat {
        get { self[HighlightLineWidthChartStyleKey.self] }
        set { self[HighlightLineWidthChartStyleKey.self] = newValue}
    }

    public var highlightLineDashPhase: CGFloat {
        get { self[HighlightLineDashPhaseChartStyleKey.self] }
        set { self[HighlightLineDashPhaseChartStyleKey.self] = newValue}
    }

    public var highlightLineDashLengths: [CGFloat]? {
        get { self[HighlightLineDashLengthsChartStyleKey.self] }
        set { self[HighlightLineDashLengthsChartStyleKey.self] = newValue}
    }
}

extension CandleChartStyle {
    public var highlightLineWidth: CGFloat {
        get { self[HighlightLineWidthChartStyleKey.self] }
        set { self[HighlightLineWidthChartStyleKey.self] = newValue}
    }

    public var highlightLineDashPhase: CGFloat {
        get { self[HighlightLineDashPhaseChartStyleKey.self] }
        set { self[HighlightLineDashPhaseChartStyleKey.self] = newValue}
    }

    public var highlightLineDashLengths: [CGFloat]? {
        get { self[HighlightLineDashLengthsChartStyleKey.self] }
        set { self[HighlightLineDashLengthsChartStyleKey.self] = newValue}
    }
}

extension BubbleChartStyle {
    public var highlightLineWidth: CGFloat {
        get { self[HighlightLineWidthChartStyleKey.self] }
        set { self[HighlightLineWidthChartStyleKey.self] = newValue}
    }

    public var highlightLineDashPhase: CGFloat {
        get { self[HighlightLineDashPhaseChartStyleKey.self] }
        set { self[HighlightLineDashPhaseChartStyleKey.self] = newValue}
    }

    public var highlightLineDashLengths: [CGFloat]? {
        get { self[HighlightLineDashLengthsChartStyleKey.self] }
        set { self[HighlightLineDashLengthsChartStyleKey.self] = newValue}
    }
}

// MARK: - Keys

private enum HighlightLineWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.5
}

private enum HighlightLineDashPhaseChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0
}

private enum HighlightLineDashLengthsChartStyleKey: ChartStyleKey {
    static let defaultValue: [CGFloat]? = nil
}
