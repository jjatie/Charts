public typealias PieChartData = ChartData<PieChartDataEntry>

extension PieChartData {
    public convenience init(dataSet: Element) {
        self.init(dataSets: [dataSet])
    }

    public var dataSet: PieChartDataSet? {
        get { first }
        set {
            if let set = newValue {
                _dataSets = [set]
            } else {
                _dataSets = []
            }
        }
    }

    /// The total y-value sum across all DataSet objects the this object represents.
    public var yValueSum: Double {
        guard let dataSet = dataSet else { return 0.0 }
        return dataSet.reduce(into: 0) {
            $0 += $1.y
        }
    }
}
