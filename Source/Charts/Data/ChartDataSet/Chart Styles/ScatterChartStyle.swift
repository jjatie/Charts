import CoreGraphics

typealias ScatterChartStyle = ChartStyle<ChartDataEntry>

extension ScatterChartStyle {
    /// The size the scatter shape will have
    public var scatterShapeSize: CGFloat {
        get { self[ScatterShapeSizeChartStyleKey.self] }
        set { self[ScatterShapeSizeChartStyleKey.self] = newValue }
    }

    /// The radius of the hole in the shape (applies to Square, Circle and Triangle)
    /// - Default: `0.0`
    /// - Note: Set this to `0` to remove holes.
    public var scatterShapeHoleRadius: CGFloat {
        get { self[ScatterShapeHoleRadiusChartStyleKey.self] }
        set { self[ScatterShapeHoleRadiusChartStyleKey.self] = newValue }
    }

    /// Color for the hole in the shape. Setting to `nil` will behave as transparent.
    /// **default**: nil
    public var scatterShapeHoleColor: NSUIColor? {
        get { self[ScatterShapeHoleColorChartStyleKey.self] }
        set { self[ScatterShapeHoleColorChartStyleKey.self] = newValue }
    }

    /// The `ShapeRenderer` responsible for rendering this DataSet.
    /// **default**: `SquareShapeRenderer`
    public var shapeRenderer: ShapeRenderer? {
        get { self[ShapeRendererChartStyleKey.self] }
        set { self[ShapeRendererChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum ScatterShapeSizeChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 10
}

private enum ScatterShapeHoleRadiusChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0
}

private enum ScatterShapeHoleColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = nil
}

private enum ShapeRendererChartStyleKey: ChartStyleKey {
    static let defaultValue: ShapeRenderer? = SquareShapeRenderer()
}
