public typealias AxisRange = (min: Double, max: Double)

func merge(_ lhs: AxisRange, _ rhs: AxisRange) -> AxisRange {
    (min(lhs.min, rhs.min), max(lhs.max, rhs.max))
}

func merge(_ lhs: AxisRange, _ rhs: Double) -> AxisRange {
    (min(lhs.min, rhs), max(lhs.max, rhs))
}
