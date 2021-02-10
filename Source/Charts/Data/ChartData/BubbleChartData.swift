import CoreGraphics

public typealias BubbleChartData = ChartData<BubbleChartDataEntry>

extension BubbleChartData {
    /// Sets the width of the circle that surrounds the bubble when highlighted for all DataSet objects this data object contains
    public final func setHighlightCircleWidth(_ width: CGFloat) {
        _dataSets.forEach { $0.highlightCircleWidth = width }
    }
}
