public struct RadarChartDataEntry: ChartDataEntry2D {
    public var x: Double = .nan
    public var y: Double = 0
    
    public var value: Double {
        get { y }
        set { y = newValue }
    }
    
    /// optional icon image
    public var icon: NSUIImage?

    public init() { }

    /// - Parameters:
    ///   - value: The value on the y-axis.
    public init(value: Double, icon: NSUIImage? = nil) {
        self.y = value
        self.icon = icon
    }
}

// MARK: - Equatable

extension RadarChartDataEntry: Equatable {
    public static func == (lhs: RadarChartDataEntry, rhs: RadarChartDataEntry) -> Bool {
        lhs.y == rhs.y
    }
}

// MARK: - CustomStringConvertible

extension RadarChartDataEntry: CustomStringConvertible { }
