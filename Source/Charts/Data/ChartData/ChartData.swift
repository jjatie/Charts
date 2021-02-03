//
//  ChartData.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

func merge(_ lhs: AxisRange, _ rhs: AxisRange) -> AxisRange {
    (min(lhs.min, rhs.min), max(lhs.max, rhs.max))
}

func merge(_ lhs: AxisRange, _ rhs: Double) -> AxisRange {
    (min(lhs.min, rhs), max(lhs.max, rhs))
}

func axisRangeBounds(_ axisRange: AxisRange, contains range: AxisRange) -> Bool {
    axisRange.min == range.min ||
        axisRange.min == range.max ||
        axisRange.max == range.min ||
        axisRange.max == range.max
}

open class ChartData: ExpressibleByArrayLiteral {
    public internal(set) var xRange: AxisRange = (0, 0)
    public var yRange: AxisRange { merge(leftAxisRange, rightAxisRange) }
    final var leftAxisRange: AxisRange = (.greatestFiniteMagnitude, -.greatestFiniteMagnitude)
    final var rightAxisRange: AxisRange = (.greatestFiniteMagnitude, -.greatestFiniteMagnitude)

    // MARK: - Accessibility

    /// When the data entry labels are generated identifiers, set this property to prepend a string before each identifier
    ///
    /// For example, if a label is "#3", settings this property to "Item" allows it to be spoken as "Item #3"
    open var accessibilityEntryLabelPrefix: String?

    /// When the data entry value requires a unit, use this property to append the string representation of the unit to the value
    ///
    /// For example, if a value is "44.1", setting this property to "m" allows it to be spoken as "44.1 m"
    open var accessibilityEntryLabelSuffix: String?

    /// If the data entry value is a count, set this to true to allow plurals and other grammatical changes
    /// **default**: false
    open var accessibilityEntryLabelSuffixIsCount: Bool = false

    var _dataSets = [Element]()

    public required init() {}

    public required init(arrayLiteral elements: Element...) {
        self._dataSets = elements
        calcMinMax()
    }

    public init(dataSets: [Element]) {
        self._dataSets = dataSets
        calcMinMax()
    }

    public convenience init(dataSet: Element) {
        self.init(dataSets: [dataSet])
        calcMinMax()
    }

    public func notifyDataChanged() {
        calcMinMax()
    }

    func calcMinMaxY(fromX: Double, toX: Double) {
        forEach { $0.calcMinMaxY(fromX: fromX, toX: toX) }

        // apply the new data
        calcMinMax()
    }

    /// calc minimum and maximum y value over all datasets
    func calcMinMax() {
        forEach(calcMinMax(dataSet:))
        leftAxisRange = calcAxisRange(.left)
        rightAxisRange = calcAxisRange(.right)
    }

    private func calcAxisRange(_ axis: YAxis.AxisDependency) -> AxisRange {
        lazy.filter { $0.axisDependency == axis }
            .map(\.yRange)
            .reduce((.greatestFiniteMagnitude, -.greatestFiniteMagnitude), merge)
    }

    /// Adjusts the current minimum and maximum values based on the provided Entry object.
    private func calcMinMax(entry e: ChartDataEntry, axis: YAxis.AxisDependency) {
        xRange = merge(xRange, e.x)

        switch axis {
        case .left:
            leftAxisRange = merge(leftAxisRange, e.y)

        case .right:
            rightAxisRange = merge(rightAxisRange, e.y)
        }
    }

    /// Adjusts the minimum and maximum values based on the given DataSet.
    private func calcMinMax(dataSet d: Element) {
        xRange = merge(xRange, d.xRange)

        switch d.axisDependency {
        case .left:
            leftAxisRange = merge(leftAxisRange, d.yRange)

        case .right:
            rightAxisRange = merge(rightAxisRange, d.yRange)
        }
    }

    open func getYMin(axis: YAxis.AxisDependency) -> Double {
        // TODO: Why does it make sense to return the other axisMin if there is none for the one requested?
        switch axis {
        case .left:
            if leftAxisRange.min == .greatestFiniteMagnitude {
                return rightAxisRange.min
            } else {
                return leftAxisRange.min
            }

        case .right:
            if rightAxisRange.min == .greatestFiniteMagnitude {
                return leftAxisRange.min
            } else {
                return rightAxisRange.min
            }
        }
    }

    open func getYMax(axis: YAxis.AxisDependency) -> Double {
        switch axis {
        case .left:
            if leftAxisRange.max == -.greatestFiniteMagnitude {
                return rightAxisRange.max
            } else {
                return leftAxisRange.max
            }

        case .right:
            if rightAxisRange.max == -.greatestFiniteMagnitude {
                return leftAxisRange.max
            } else {
                return rightAxisRange.max
            }
        }
    }

    /// Get the Entry for a corresponding highlight object
    ///
    /// - Parameters:
    ///   - highlight:
    /// - Returns: The entry that is highlighted
    open func entry(for highlight: Highlight) -> ChartDataEntry? {
        guard highlight.dataSetIndex < endIndex else { return nil }
        return self[highlight.dataSetIndex].element(withX: highlight.x, closestToY: highlight.y)
    }

    /// Adds an Entry to the DataSet at the specified index. Entries are added to the end of the list.
    open func appendEntry(_ e: ChartDataEntry, toDataSet dataSetIndex: Index) {
        guard indices.contains(dataSetIndex) else {
            return print("ChartData.addEntry() - Cannot add Entry because dataSetIndex too high or too low.", terminator: "\n")
        }

        let set = self[dataSetIndex]
        set.append(e)
        calcMinMax(entry: e, axis: set.axisDependency)
    }

    /// Removes the given Entry object from the DataSet at the specified index.
    @discardableResult open func removeEntry(_ entry: ChartDataEntry, dataSetIndex: Index) -> Bool {
        guard indices.contains(dataSetIndex) else { return false }

        // remove the entry from the dataset
        let removed = self[dataSetIndex].remove(entry)

        if removed {
            calcMinMax()
        }

        return removed
    }

    /// - Returns: The DataSet that contains the provided Entry, or null, if no DataSet contains this entry.
    open func getDataSetForEntry(_ e: ChartDataEntry) -> Element? {
        first { $0.contains(e) }
    }

    /// Sets a custom ValueFormatter for all DataSets this data object contains.
    open func setValueFormatter(_ formatter: ValueFormatter) {
        forEach { $0.valueFormatter = formatter }
    }

    /// Sets the color of the value-text (color in which the value-labels are drawn) for all DataSets this data object contains.
    open func setValueTextColor(_ color: NSUIColor) {
        forEach { $0.valueTextColor = color }
    }

    /// Sets the font for all value-labels for all DataSets this data object contains.
    open func setValueFont(_ font: NSUIFont) {
        forEach { $0.valueFont = font }
    }

    /// Enables / disables drawing values (value-text) for all DataSets this data object contains.
    open func setDrawValues(_ enabled: Bool) {
        forEach { $0.isDrawValuesEnabled = enabled }
    }

    /// Enables / disables highlighting values for all DataSets this data object contains.
    /// If set to true, this means that values can be highlighted programmatically or by touch gesture.
    open var isHighlightEnabled: Bool {
        get { allSatisfy { $0.isHighlightingEnabled } }
        set { forEach { $0.isHighlightingEnabled = newValue } }
    }

    /// Clears this data object from all DataSets and removes all Entries.
    /// Don't forget to invalidate the chart after this.
    open func clearValues() {
        removeAll(keepingCapacity: false)
    }

    /// The total entry count across all DataSet objects this data object contains.
    open var entryCount: Int {
        reduce(0) { return $0 + $1.count }
    }

    /// The DataSet object with the maximum number of entries or null if there are no DataSets.
    open var maxEntryCountSet: Element? {
        self.max { $0.count > $1.count }
    }
}

// MARK: MutableCollection

extension ChartData: MutableCollection {
    public typealias Index = Int
    public typealias Element = ChartDataSet

    public var startIndex: Index {
        _dataSets.startIndex
    }

    public var endIndex: Index {
        _dataSets.endIndex
    }

    public func index(after: Index) -> Index {
        _dataSets.index(after: after)
    }

    public subscript(position: Index) -> Element {
        get { _dataSets[position] }
        set {
            calcMinMax(dataSet: newValue)
            _dataSets[position] = newValue
        }
    }
}

// MARK: RandomAccessCollection

extension ChartData: RandomAccessCollection {
    public func index(before: Index) -> Index {
        _dataSets.index(before: before)
    }
}

// MARK: RangeReplaceableCollection

extension ChartData: RangeReplaceableCollection
{
    public func append(_ newElement: Element) {
        _dataSets.append(newElement)
        calcMinMax(dataSet: newElement)
    }

    @discardableResult
    public func remove(at position: Index) -> Element {
        let element = _dataSets.remove(at: position)
        calcMinMax()
        return element
    }

    @discardableResult
    public func removeFirst() -> Element {
        assert(!(self is CombinedChartData), "\(#function) not supported for CombinedData")

        let element = _dataSets.removeFirst()
        calcMinMax()
        return element
    }

    public func removeFirst(_ n: Int) {
        assert(!(self is CombinedChartData), "\(#function) not supported for CombinedData")

        _dataSets.removeFirst(n)
        calcMinMax()
    }

    @discardableResult
    public func removeLast() -> Element {
        assert(!(self is CombinedChartData), "\(#function) not supported for CombinedData")

        let element = _dataSets.removeLast()
        calcMinMax()
        return element
    }

    public func removeLast(_ n: Int) {
        assert(!(self is CombinedChartData), "\(#function) not supported for CombinedData")

        _dataSets.removeLast(n)
        calcMinMax()
    }

    public func removeSubrange<R>(_ bounds: R) where R: RangeExpression, Index == R.Bound {
        assert(!(self is CombinedChartData), "\(#function) not supported for CombinedData")

        _dataSets.removeSubrange(bounds)
        calcMinMax()
    }

    public func removeAll(keepingCapacity keepCapacity: Bool) {
        assert(!(self is CombinedChartData), "\(#function) not supported for CombinedData")

        _dataSets.removeAll(keepingCapacity: keepCapacity)
        calcMinMax()
    }

    public func replaceSubrange<C>(_ subrange: Swift.Range<Index>, with newElements: C) where C: Collection, Element == C.Element
    {
        assert(!(self is CombinedChartData), "\(#function) not supported for CombinedData")

        _dataSets.replaceSubrange(subrange, with: newElements)
        newElements.forEach { self.calcMinMax(dataSet: $0) }
    }
}

// MARK: Swift Accessors

public extension ChartData {
    /// Retrieve the index of a ChartDataSet with a specific label from the ChartData. Search can be case sensitive or not.
    /// **IMPORTANT: This method does calculations at runtime, do not over-use in performance critical situations.**
    ///
    /// - Parameters:
    ///   - label: The label to search for
    ///   - ignoreCase: if true, the search is not case-sensitive
    /// - Returns: The index of the DataSet Object with the given label. `nil` if not found
    func index(ofLabel label: String, ignoreCase: Bool) -> Index? {
        return ignoreCase
            ? firstIndex { $0.label?.caseInsensitiveCompare(label) == .orderedSame }
            : firstIndex { $0.label == label }
    }
}
