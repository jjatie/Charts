public struct BarChartDataEntry: ChartDataEntry2D {
    public var x: Double = 0.0
    public var y: Double = 0.0

    /// optional icon image
    public var icon: NSUIImage?

    /// the values the stacked barchart holds
    private var _yVals: [Double]?

    /// The ranges of the individual stack-entries. Will return null if this entry is not stacked.
    public private(set) var ranges: [ClosedRange<Double>]?

    /// The sum of all negative values this entry (if stacked) contains. (this is a positive number)
    public private(set) var negativeSum: Double = 0.0

    /// The sum of all positive values this entry (if stacked) contains.
    public private(set) var positiveSum: Double = 0.0

    /// the values the stacked barchart holds
    public var isStacked: Bool { _yVals != nil }

    /// the values the stacked barchart holds
    public var yValues: [Double]? {
        get { self._yVals }
        set {
            self.y = BarChartDataEntry.calcSum(values: newValue ?? [])
            self._yVals = newValue
            (negativeSum, positiveSum) = calcPosNegSum(newValue ?? [])
            self.ranges = newValue.map(calcRanges)
        }
    }

    var stackSize: Int { yValues?.count ?? 1 }

    public init() { }

    public init(x: Double, y: Double, icon: NSUIImage? = nil) {
        self.x = x
        self.y = y
        self.icon = icon
    }

    /// Constructor for stacked bar entries.
    public init(x: Double, yValues: [Double], icon: NSUIImage? = nil) {
        self.init(x: x, y: BarChartDataEntry.calcSum(values: yValues), icon: icon)
        _yVals = yValues
        (negativeSum, positiveSum) = calcPosNegSum(yValues)
        self.ranges = calcRanges(yValues)
    }

    // MARK: Utilities

    /// Calculates the sum across all values of the given stack.
    private static func calcSum(values: [Double]) -> Double {
        values.reduce(into: 0, +=)
    }

    private func sumBelow(stackIndex: Int) -> Double {
        guard let yVals = _yVals, yVals.indices.contains(stackIndex) else {
            return 0
        }

        let remainder = yVals[stackIndex...].reduce(into: 0.0) { $0 += $1 }
        return remainder
    }

    private func calcPosNegSum(_ values: [Double]) -> (negativeSum: Double, positiveSum: Double) {
        values.reduce(into: (0, 0)) { result, y in
            if y < 0 {
                result.0 -= y
            } else {
                result.1 += y
            }
        }
    }

    /// Splits up the stack-values of the given bar-entry into Range objects.
    ///
    /// - Parameters:
    ///   - entry:
    /// - Returns:
    private func calcRanges(_ values: [Double]) -> [ClosedRange<Double>] {
        guard !values.isEmpty else { return [] }

        var ranges = [ClosedRange<Double>]()
        ranges.reserveCapacity(values.count)

        var negRemain = -negativeSum
        var posRemain: Double = 0.0

        for value in values {
            if value < 0 {
                ranges.append(negRemain...(negRemain - value))
                negRemain -= value
            } else {
                ranges.append(posRemain...(posRemain + value))
                posRemain += value
            }
        }
        
        return ranges
    }
}

// MARK: - Equatable

extension BarChartDataEntry: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs._yVals == rhs._yVals &&
            lhs.icon == rhs.icon
    }
}

// MARK: - CustomStringConvertible

extension BarChartDataEntry: CustomStringConvertible { }
