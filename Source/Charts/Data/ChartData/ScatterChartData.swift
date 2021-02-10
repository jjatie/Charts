import CoreGraphics

public typealias ScatterChartData = ChartData<ChartDataEntry>

extension ScatterChartData {
    /// - Returns: The maximum shape-size across all DataSets.
    public func getGreatestShapeSize() -> CGFloat {
        self.max { $0.scatterShapeSize < $1.scatterShapeSize }?
            .scatterShapeSize ?? 0
    }
}
