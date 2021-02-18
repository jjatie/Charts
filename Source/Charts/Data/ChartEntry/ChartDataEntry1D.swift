public protocol ChartDataEntry1D: Equatable {
    /// the y value
    var y: Double { get }
}

extension Equatable where Self: ChartDataEntry1D {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.y == rhs.y
    }
}

extension CustomStringConvertible where Self: ChartDataEntry1D {
    public var description: String {
        "ChartDataEntryBase, y \(y)"
    }
}
