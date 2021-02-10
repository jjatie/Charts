import Foundation

public struct ChartData<EntryType: ChartDataEntry> {
    public internal(set) var xRange: AxisRange = (0, 0)
    public var yRange: AxisRange { merge(leftAxisRange, rightAxisRange) }
    var leftAxisRange: AxisRange = (.greatestFiniteMagnitude, -.greatestFiniteMagnitude)
    var rightAxisRange: AxisRange = (.greatestFiniteMagnitude, -.greatestFiniteMagnitude)

    // MARK: - Accessibility

    /// When the data entry labels are generated identifiers, set this property to prepend a string before each identifier
    ///
    /// For example, if a label is "#3", settings this property to "Item" allows it to be spoken as "Item #3"
    public var accessibilityEntryLabelPrefix: String?

    /// When the data entry value requires a unit, use this property to append the string representation of the unit to the value
    ///
    /// For example, if a value is "44.1", setting this property to "m" allows it to be spoken as "44.1 m"
    public var accessibilityEntryLabelSuffix: String?

    /// If the data entry value is a count, set this to true to allow plurals and other grammatical changes
    /// **default**: false
    public var accessibilityEntryLabelSuffixIsCount: Bool = false

    var _dataSets: [Element]

    public init() {
        _dataSets = []
    }

    public init(dataSets: [Element]) {
        self._dataSets = dataSets
        calcMinMax()
    }

    public init(dataSet: Element) {
        self.init(dataSets: [dataSet])
        calcMinMax()
    }

    public mutating func notifyDataChanged() {
        calcMinMax()
    }

    mutating func calcMinMaxY(fromX: Double, toX: Double) {
        indices.forEach { self[$0].calcMinMaxY(fromX: fromX, toX: toX) }

        // apply the new data
        calcMinMax()
    }

    /// calc minimum and maximum y value over all datasets
    mutating func calcMinMax() {
        forEach { calcMinMax(dataSet:$0) }
        leftAxisRange = calcAxisRange(.left)
        rightAxisRange = calcAxisRange(.right)
    }

    private func calcAxisRange(_ axis: YAxis.AxisDependency) -> AxisRange {
        lazy.filter { $0.axisDependency == axis }
            .map(\.yRange)
            .reduce((.greatestFiniteMagnitude, -.greatestFiniteMagnitude), merge)
    }

    /// Adjusts the current minimum and maximum values based on the provided Entry object.
    private mutating func calcMinMax(entry e: EntryType, axis: YAxis.AxisDependency) {
        xRange = merge(xRange, e.x)

        switch axis {
        case .left:
            leftAxisRange = merge(leftAxisRange, e.y)

        case .right:
            rightAxisRange = merge(rightAxisRange, e.y)
        }
    }

    /// Adjusts the minimum and maximum values based on the given DataSet.
    private mutating func calcMinMax(dataSet d: Element) {
        xRange = merge(xRange, d.xRange)

        switch d.axisDependency {
        case .left:
            leftAxisRange = merge(leftAxisRange, d.yRange)

        case .right:
            rightAxisRange = merge(rightAxisRange, d.yRange)
        }
    }

    public func getYMin(axis: YAxis.AxisDependency) -> Double {
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

    public func getYMax(axis: YAxis.AxisDependency) -> Double {
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

    /// Adds an Entry to the DataSet at the specified index. Entries are added to the end of the list.
    public mutating func appendEntry(_ e: EntryType, toDataSet dataSetIndex: Index) {
        guard indices.contains(dataSetIndex) else {
            return print("ChartData.addEntry() - Cannot add Entry because dataSetIndex too high or too low.", terminator: "\n")
        }

        self[dataSetIndex].append(e)
        calcMinMax(entry: e, axis: self[dataSetIndex].axisDependency)
    }

    /// Removes the given Entry object from the DataSet at the specified index.
    @discardableResult public mutating func removeEntry(_ entry: EntryType, dataSetIndex: Index) -> Bool {
        guard indices.contains(dataSetIndex) else { return false }

        // remove the entry from the dataset
        let removed = self[dataSetIndex].remove(entry)

        if removed {
            calcMinMax()
        }

        return removed
    }

    /// - Returns: The DataSet that contains the provided Entry, or null, if no DataSet contains this entry.
    public func getDataSetForEntry(_ e: EntryType) -> Element? {
        first { $0.contains(e) }
    }

    /// Sets a custom ValueFormatter for all DataSets this data object contains.
    public mutating func setValueFormatter(_ formatter: ValueFormatter) {
        indices.forEach { self[$0].valueFormatter = formatter }
    }

    /// Sets the color of the value-text (color in which the value-labels are drawn) for all DataSets this data object contains.
    public mutating func setValueTextColor(_ color: NSUIColor) {
        indices.forEach { self[$0].valueTextColor = color }
    }

    /// Sets the font for all value-labels for all DataSets this data object contains.
    public mutating func setValueFont(_ font: NSUIFont) {
        indices.forEach { self[$0].valueFont = font }
    }

    /// Enables / disables drawing values (value-text) for all DataSets this data object contains.
    public mutating func setDrawValues(_ enabled: Bool) {
        indices.forEach { self[$0].isDrawValuesEnabled = enabled }
    }

    /// The total entry count across all DataSet objects this data object contains.
    public var entryCount: Int {
        reduce(0) { return $0 + $1.count }
    }

    /// The DataSet object with the maximum number of entries or null if there are no DataSets.
    public var maxEntryCountSet: Element? {
        self.max { $0.count > $1.count }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension ChartData: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self._dataSets = elements
        calcMinMax()
    }
}

// MARK: - MutableCollection

extension ChartData: MutableCollection {
    public typealias Index = Int
    public typealias Element = ChartDataSet<EntryType>

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

// MARK: - RandomAccessCollection

extension ChartData: RandomAccessCollection {
    public func index(before: Index) -> Index {
        _dataSets.index(before: before)
    }
}

// MARK: - RangeReplaceableCollection

extension ChartData: RangeReplaceableCollection
{
    public mutating func append(_ newElement: Element) {
        _dataSets.append(newElement)
        calcMinMax(dataSet: newElement)
    }

    @discardableResult
    public mutating func remove(at position: Index) -> Element {
        let element = _dataSets.remove(at: position)
        calcMinMax()
        return element
    }

    @discardableResult
    public mutating func removeFirst() -> Element {
        let element = _dataSets.removeFirst()
        calcMinMax()
        return element
    }

    public mutating func removeFirst(_ n: Int) {
        _dataSets.removeFirst(n)
        calcMinMax()
    }

    @discardableResult
    public mutating func removeLast() -> Element {
        let element = _dataSets.removeLast()
        calcMinMax()
        return element
    }

    public mutating func removeLast(_ n: Int) {
        _dataSets.removeLast(n)
        calcMinMax()
    }

    public mutating func removeSubrange<R>(_ bounds: R) where R: RangeExpression, Index == R.Bound {
        _dataSets.removeSubrange(bounds)
        calcMinMax()
    }

    public mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        _dataSets.removeAll(keepingCapacity: keepCapacity)
        calcMinMax()
    }

    public mutating func replaceSubrange<C>(_ subrange: Swift.Range<Index>, with newElements: C) where C: Collection, Element == C.Element
    {
        _dataSets.replaceSubrange(subrange, with: newElements)
        newElements.forEach { self.calcMinMax(dataSet: $0) }
    }
}

// MARK: - Swift Accessors

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
