public typealias CandleChartDataSet = ChartDataSet<CandleChartDataEntry>

extension CandleChartDataSet {
    mutating func calcMinMax(entry e: Element) {
        yRange.min = Swift.min(e.low, yRange.min)
        yRange.max = Swift.max(e.high, yRange.max)

        calcMinMaxX(entry: e)
    }

    mutating func calcMinMaxY(entry e: Element) {
        yRange.min = Swift.min(e.low, yRange.max)
        yRange.max = Swift.max(e.high, yRange.max)
    }
}
