import CoreGraphics

public typealias BarChartData = ChartData<BarChartDataEntry>

extension BarChartData {
    /// Groups all BarDataSet objects this data object holds together by modifying the x-value of their entries.
    /// Previously set x-values of entries will be overwritten. Leaves space between bars and groups as specified by the parameters.
    /// Do not forget to call notifyDataSetChanged() on your BarChart object after calling this method.
    ///
    /// - Parameters:
    ///   - fromX: the starting point on the x-axis where the grouping should begin
    ///   - groupSpace: The space between groups of bars in values (not pixels) e.g. 0.8f for bar width 1f
    ///   - barSpace: The space between individual bars in values (not pixels) e.g. 0.1f for bar width 1f
    public mutating func groupBars(fromX: Double, groupSpace: Double, barWidth: Double, barSpace: Double) {
        guard let max = maxEntryCountSet else {
            print("BarData needs to hold at least 2 BarDataSets to allow grouping.", terminator: "\n")
            return
        }

        let groupSpaceWidthHalf = groupSpace / 2.0
        let barSpaceHalf = barSpace / 2.0
        let barWidthHalf = barWidth / 2.0

        var fromX = fromX

        let interval = groupWidth(groupSpace: groupSpace, barWidth: barWidth, barSpace: barSpace)

        for i in max.indices {
            let start = fromX
            fromX += groupSpaceWidthHalf

            for j in _dataSets.indices {
                fromX += barSpaceHalf
                fromX += barWidthHalf

                if _dataSets[j].indices.contains(i) {
                    _dataSets[j][i].x = fromX
                }

                fromX += barWidthHalf
                fromX += barSpaceHalf
            }

            fromX += groupSpaceWidthHalf
            let end = fromX
            let innerInterval = end - start
            let diff = interval - innerInterval

            // correct rounding errors
            if diff > 0 || diff < 0 {
                fromX += diff
            }
        }

        calcMinMax()
    }

    /// In case of grouped bars, this method returns the space an individual group of bar needs on the x-axis.
    ///
    /// - Parameters:
    ///   - groupSpace:
    ///   - barSpace:
    public func groupWidth(groupSpace: Double, barWidth: Double, barSpace: Double) -> Double {
        Double(count) * (barWidth + barSpace) + groupSpace
    }
}
