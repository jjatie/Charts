public protocol ChartDataEntry2D: ChartDataEntry1D {
    /// the x value
    var x: Double { get }
}

extension Equatable where Self: ChartDataEntry2D {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension CustomStringConvertible where Self: ChartDataEntry2D {
    public var description: String {
        "ChartDataEntry, x: \(x), y \(y)"
    }
}
