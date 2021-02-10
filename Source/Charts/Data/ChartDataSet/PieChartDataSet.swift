public typealias PieChartDataSet = ChartDataSet<PieChartDataEntry>

extension PieChartDataSet {
    mutating func calcMinMax(entry e: Element) {
        calcMinMaxY(entry: e)
    }
}
