import CoreGraphics

extension DataRenderer {
    /// Draws vertical & horizontal highlight-lines if enabled.
    /// :param: context
    /// :param: points
    /// :param: horizontal
    /// :param: vertical
    public func drawHighlightLines<EntryType: ChartDataEntry>(
        context: CGContext,
        point: CGPoint,
        set: ChartDataSet<EntryType>
    ) {
        // draw vertical highlight lines
        if set.isVerticalHighlightIndicatorEnabled {
            context.beginPath()
            context.move(to: CGPoint(x: point.x, y: viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: point.x, y: viewPortHandler.contentBottom))
            context.strokePath()
        }

        // draw horizontal highlight lines
        if set.isHorizontalHighlightIndicatorEnabled {
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: point.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: point.y))
            context.strokePath()
        }
    }
}
