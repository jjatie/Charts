public typealias BarChartDataSet = ChartDataSet<BarChartDataEntry>

extension BarChartDataSet {
    /// The maximum number of bars that can be stacked upon another in this DataSet.
    /// This value is calculated from the Entries that are added to the DataSet
    /// - Complexity: O(n) where `n` is the number of entries in this data set
    public var stackSize: Int {
        entries.lazy
            .map(\.stackSize)
            .max() ?? 1
    }

    /// `true` if this DataSet is stacked (stacksize > 1) or not.
    public var isStacked: Bool {
        stackSize > 1
    }

    mutating func calcMinMax(entry e: Element) {
        guard !e.y.isNaN else { return }

        if e.yValues == nil {
            yRange = merge(yRange, e.y)
        } else {
            yRange = merge(yRange, (-e.negativeSum, e.positiveSum))
        }

        calcMinMaxX(entry: e)
    }
}
