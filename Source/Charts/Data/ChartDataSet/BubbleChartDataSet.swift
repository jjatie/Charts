public typealias BubbleChartDataSet = ChartDataSet<BubbleChartDataEntry>

extension BubbleChartDataSet {
    func calcMinMax(entry e: Element) {
        calcMinMaxX(entry: e)
        calcMinMaxY(entry: e)
        style.maxSize = Swift.max(e.size, style.maxSize)
    }
}