/// Class representing the bounds of the current viewport in terms of indices in the values array of a DataSet.
public class XBounds {
    /// minimum visible entry index
    public var min: Int = 0

    /// maximum visible entry index
    public var max: Int = 0

    /// range of visible entry indices
    public var range: Int = 0

    public init() {}

    public init(
        chart: BarLineScatterCandleBubbleChartDataProvider,
        dataSet: BarLineScatterCandleBubbleChartDataSet,
        animator: Animator?
    ) {
        set(chart: chart, dataSet: dataSet, animator: animator)
    }

    /// Calculates the minimum and maximum x values as well as the range between them.
    public func set(
        chart: BarLineScatterCandleBubbleChartDataProvider,
        dataSet: BarLineScatterCandleBubbleChartDataSet,
        animator: Animator?
    ) {
        let phaseX = Swift.max(0.0, Swift.min(1.0, animator?.phaseX ?? 1.0))

        let low = chart.lowestVisibleX
        let high = chart.highestVisibleX

        let entryFrom = dataSet.entryForXValue(low, closestToY: .nan, rounding: .down)
        let entryTo = dataSet.entryForXValue(high, closestToY: .nan, rounding: .up)

        min = entryFrom.flatMap(dataSet.firstIndex(of:)) ?? 0
        max = entryTo.flatMap(dataSet.firstIndex(of:)) ?? 0
        range = Int(Double(max - min) * phaseX)
    }
}

extension XBounds: RangeExpression {
    public typealias Bound = Int
    public func relative<C>(to collection: C) -> Range<Bound> where
        C : Collection, Bound == C.Index
    {
        return Swift.Range<Bound>(min ... min + range)
    }

    public func contains(_ element: Int) -> Bool {
        return (min ... min + range).contains(element)
    }
}

extension XBounds: Sequence {
    public struct Iterator: IteratorProtocol {
        private var iterator: IndexingIterator<ClosedRange<Int>>

        fileprivate init(min: Int, max: Int) {
            iterator = (min ... max).makeIterator()
        }

        public mutating func next() -> Int? {
            return iterator.next()
        }
    }

    public func makeIterator() -> Iterator {
        return Iterator(min: min, max: min + range)
    }
}

extension XBounds: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "min:\(min), max:\(max), range:\(range)"
    }
}
