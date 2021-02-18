public struct CandleChartDataEntry: ChartDataEntry2D {
    public var x: Double = 0.0

    /// the center value of the candle. (Middle value between high and low)
    public var y: Double {
        get { _y }
        set { _y = (high + low) / 2.0 }
    }
    private var _y: Double = 0

    /// optional icon image
    public var icon: NSUIImage?

    /// shadow-high value
    public var high: Double = 0

    /// shadow-low value
    public var low: Double = 0

    /// close value
    public var close: Double = 0

    /// public value
    public var open: Double = 0

    /// The overall range (difference) between shadow-high and shadow-low.
    public var shadowRange: Double {
        abs(high - low)
    }

    /// The body size (difference between public and close).
    public var bodyRange: Double {
        abs(open - close)
    }

    public init() { }

    public init(
        x: Double,
        shadowH: Double,
        shadowL: Double,
        open: Double,
        close: Double,
        icon: NSUIImage? = nil
    ) {
        self.x = x
        self._y = (shadowH + shadowL) / 2.0
        self.icon = icon
        self.high = shadowH
        self.low = shadowL
        self.open = open
        self.close = close
    }
}

// MARK: - Equatable

extension CandleChartDataEntry: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x &&
            lhs._y == rhs._y &&
            lhs.high == rhs.high &&
            lhs.low == rhs.low &&
            lhs.open == rhs.open &&
            lhs.close == rhs.close &&
            lhs.icon == rhs.icon
    }
}

// MARK: - CustomStringConvertible

extension CandleChartDataEntry: CustomStringConvertible { }
