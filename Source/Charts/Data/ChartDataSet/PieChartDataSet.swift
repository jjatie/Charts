public typealias PieChartDataSet = ChartDataSet<PieChartDataEntry>

extension PieChartDataSet {
    private func initialize() {
        // TODO:
        style.valueTextColor = NSUIColor.white
        style.valueFont = NSUIFont.systemFont(ofSize: 13.0)
    }

    func calcMinMax(entry e: Element) {
        calcMinMaxY(entry: e)
    }
}
