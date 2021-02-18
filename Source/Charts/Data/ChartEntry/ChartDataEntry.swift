public struct ChartDataEntry: ChartDataEntry2D {
    public var x: Double
    public var y: Double
    
    /// optional icon image
    public var icon: NSUIImage?
    
    public init(x: Double, y: Double, icon: NSUIImage? = nil) {
        self.x = x
        self.y = y
        self.icon = icon
    }
}
