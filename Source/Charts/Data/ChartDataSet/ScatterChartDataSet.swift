public typealias ScatterChartDataSet = ChartDataSet<ChartDataEntry>

extension ScatterChartDataSet {
    public enum Shape {
        case square
        case circle
        case triangle
        case cross
        case x
        case chevronUp
        case chevronDown
    }

    static func renderer(forShape shape: Shape) -> ShapeRenderer {
        switch shape {
        case .square: return SquareShapeRenderer()
        case .circle: return CircleShapeRenderer()
        case .triangle: return TriangleShapeRenderer()
        case .cross: return CrossShapeRenderer()
        case .x: return XShapeRenderer()
        case .chevronUp: return ChevronUpShapeRenderer()
        case .chevronDown: return ChevronDownShapeRenderer()
        }
    }

    /// Sets the ScatterShape this DataSet should be drawn with.
    /// This will search for an available ShapeRenderer and set this renderer for the DataSet
    public func setScatterShape(_ shape: Shape) {
        style.shapeRenderer = ScatterChartDataSet.renderer(forShape: shape)
    }
}
