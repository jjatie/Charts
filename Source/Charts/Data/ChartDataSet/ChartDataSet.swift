//
//  ChartDataSet.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Algorithms
import Foundation
import CoreGraphics

/// Determines how to round DataSet index values for `ChartDataSet.entryIndex(x, rounding)` when an exact x-value is not found.
public enum ChartDataSetRounding {
    case up
    case down
    case closest
}

public typealias AxisRange = (min: Double, max: Double)

public typealias ARange = ClosedRange<Double>


/// The DataSet class represents one group or type of entries (Entry) in the Chart that belong together.
/// It is designed to logically separate different groups of values inside the Chart (e.g. the values for a specific line in the LineChart, or the values of a specific group of bars in the BarChart).
@dynamicMemberLookup
public class ChartDataSet: ChartDataSetProtocol, NSCopying {
    /// - Note: Calls `notifyDataSetChanged()` after setting a new value.
    /// - Returns: The array of y-values that this DataSet represents.
    /// the entries that this dataset represents / holds together
    private(set) var entries: [ChartDataEntry]

    /// The label string that describes the DataSet.
    public var label: String? = "DataSet"

    public var style = ChartStyleValues<Element>()

    /// The axis this DataSet should be plotted against.
    public var axisDependency = YAxis.AxisDependency.left

    public internal(set) var xRange: AxisRange = (.greatestFiniteMagnitude, -.greatestFiniteMagnitude)
    public internal(set) var yRange: AxisRange = (.greatestFiniteMagnitude, -.greatestFiniteMagnitude)

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<ChartStyleValues<Element>, T>) -> T {
        get { style[keyPath: keyPath] }
        set { style[keyPath: keyPath] = newValue }
    }

    public required init() {
        self.entries = []
    }

    public init(entries: [ChartDataEntry] = [], label: String = "DataSet") {
        self.entries = entries
        self.label = label
        calcMinMax()
    }

    // MARK: - Data functions and accessors

    /// Used to replace all entries of a data set while retaining styling properties.
    /// This is a separate method from a setter on `entries` to encourage usage
    /// of `Collection` conformances.
    ///
    /// - Parameter entries: new entries to replace existing entries in the dataset
    public func replaceEntries(_ entries: [ChartDataEntry]) {
        self.entries = entries
        notifyDataSetChanged()
    }

    public func calcMinMax() {
        yRange.min = Double.greatestFiniteMagnitude
        yRange.max = -Double.greatestFiniteMagnitude
        xRange.min = Double.greatestFiniteMagnitude
        xRange.max = -Double.greatestFiniteMagnitude

        guard !isEmpty else { return }

        forEach(calcMinMax)
    }

    public func calcMinMaxY(fromX: Double, toX: Double) {
        yRange.min = Double.greatestFiniteMagnitude
        yRange.max = -Double.greatestFiniteMagnitude

        guard !isEmpty,
              let indexFrom = index(ofX: fromX, closestToY: .nan, rounding: .down),
              let indexTo = self[indexFrom...].index(ofX: toX, closestToY: .nan, rounding: .up),
              indexTo >= indexFrom
        else { return }

        // only recalculate y
        self[indexFrom...indexTo].forEach(calcMinMaxY)
    }

    public func calcMinMaxX(entry e: Element) {
        xRange.min = Swift.min(e.x, xRange.min)
        xRange.max = Swift.max(e.x, xRange.max)
    }

    public func calcMinMaxY(entry e: Element) {
        yRange = (Swift.min(e.y, yRange.min), Swift.max(e.y, yRange.max))
    }

    /// Updates the min and max x and y value of this DataSet based on the given Entry.
    ///
    /// - Parameters:
    ///   - e:
    public func calcMinMax(entry e: ChartDataEntry) {
        calcMinMaxX(entry: e)
        calcMinMaxY(entry: e)
    }

    /// Adds an Entry to the DataSet dynamically.
    /// Entries are added to their appropriate index respective to it's x-index.
    /// This will also recalculate the current minimum and maximum values of the DataSet and the value-sum.
    ///
    /// - Parameters:
    ///   - e: the entry to add
    public func addEntryOrdered(_ e: ChartDataEntry) {
        if let last = last, last.x > e.x,
           let startIndex = index(ofX: e.x, closestToY: e.y, rounding: .up),
           let closestIndex = self[startIndex...].lastIndex(where: { $0.x < e.x }) {
            insert(e, at: closestIndex)
        } else {
            append(e)
        }
    }

    /// Removes an Entry from the DataSet dynamically.
    /// This will also recalculate the current minimum and maximum values of the DataSet and the value-sum.
    ///
    /// - Parameters:
    ///   - entry: the entry to remove
    /// - Returns: `true` if the entry was removed successfully, else if the entry does not exist
    public func remove(_ entry: ChartDataEntry) -> Bool {
        guard let index = firstIndex(of: entry) else { return false }
        _ = remove(at: index)
        return true
    }

    // MARK: - NSCopying

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = type(of: self).init()
        copy.entries = entries
        copy.label = label
        copy.axisDependency = axisDependency
        copy.xRange = yRange
        copy.yRange = xRange

        return copy
    }
}

// MARK: - Styling functions and accessors

extension ChartDataSet {
    public func color(at index: Int) -> NSUIColor {
        style.colors[index % style.colors.count]
    }

    public func valueTextColorAt(_ index: Int) -> NSUIColor {
        style.valueColors[index % style.valueColors.count]
    }

    public func addColor(_ color: NSUIColor) {
        style.colors.append(color)
    }

    public func setColor(_ color: NSUIColor) {
        style.colors.removeAll(keepingCapacity: false)
        style.colors.append(color)
    }

    public func setColor(_ color: NSUIColor, alpha: CGFloat) {
        setColor(color.withAlphaComponent(alpha))
    }

    public func setColors(_ colors: [NSUIColor], alpha: CGFloat) {
        self.style.colors = colors.map { $0.withAlphaComponent(alpha) }
    }

    public func setColors(_ colors: NSUIColor...) {
        self.style.colors = colors
    }
}

// MARK: - MutableCollection

extension ChartDataSet: MutableCollection {
    public typealias Index = Int
    public typealias Element = ChartDataEntry

    public var startIndex: Index {
        entries.startIndex
    }

    public var endIndex: Index {
        entries.endIndex
    }

    public func index(after: Index) -> Index {
        entries.index(after: after)
    }

    public var count: Int {
        entries.count
    }

    public subscript(position: Index) -> Element {
        get {
            // This is intentionally not a safe subscript to mirror
            // the behaviour of the built in Swift Collection Types
            entries[position]
        }
        set {
            calcMinMax(entry: newValue)
            entries[position] = newValue
        }
    }
}

// MARK: RandomAccessCollection

extension ChartDataSet: RandomAccessCollection {
    public func index(before: Index) -> Index {
        entries.index(before: before)
    }
}

// MARK: RangeReplaceableCollection

extension ChartDataSet: RangeReplaceableCollection {
    public func append(_ newElement: Element) {
        calcMinMax(entry: newElement)
        entries.append(newElement)
    }

    public func insert(_ newElement: ChartDataEntry, at i: Int) {
        calcMinMax(entry: newElement)
        entries.insert(newElement, at: i)
    }

    // TODO: Optimize when to calculate min/max
    public func remove(at position: Index) -> Element {
        let element = entries.remove(at: position)
        notifyDataSetChanged()
        return element
    }

    public func removeFirst() -> Element {
        let element = entries.removeFirst()
        notifyDataSetChanged()
        return element
    }

    public func removeFirst(_ n: Int) {
        entries.removeFirst(n)
        notifyDataSetChanged()
    }

    public func removeLast() -> Element {
        let element = entries.removeLast()
        notifyDataSetChanged()
        return element
    }

    public func removeLast(_ n: Int) {
        entries.removeLast(n)
        notifyDataSetChanged()
    }

    public func removeSubrange<R>(_ bounds: R) where R: RangeExpression, Index == R.Bound {
        entries.removeSubrange(bounds)
        notifyDataSetChanged()
    }

    public func removeAll(keepingCapacity keepCapacity: Bool) {
        entries.removeAll(keepingCapacity: keepCapacity)
        notifyDataSetChanged()
    }
}

// MARK: - CustomStringConvertible
extension ChartDataSet: CustomStringConvertible {
    public var description: String {
        String(format: "%@, label: %@, %i entries", arguments: [NSStringFromClass(type(of: self)), self.label ?? "", self.count])
    }
}

// MARK: - CustomDebugStringConvertible
extension ChartDataSet: CustomDebugStringConvertible {
    public var debugDescription: String {
        reduce(into: description + ":") {
            $0 += "\n\($1.description)"
        }
    }
}

extension ChartDataSet {
    /// Use this method to tell the data set that the underlying data has changed
    public func notifyDataSetChanged() {
        calcMinMax()
    }
}

extension BidirectionalCollection where
    Element: ChartDataEntry
{
    /// - Parameters:
    ///   - xValue: the x-value
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: determine whether to round up/down/closest if there is no Entry matching the provided x-value
    /// - Returns: The first element object found at the given x-value with binary search.
    /// If the no Entry at the specified x-value is found, this method returns the Entry at the closest x-value according to the rounding.
    /// nil if no Entry object at that x-value.
    public func element(
        withX xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding = .closest
    ) -> Element? {
        index(ofX: xValue, closestToY: yValue, rounding: rounding)
            .map { self[$0] }
    }

    /// - Returns: All Entry objects found at the given xIndex with binary search.
    /// An empty array if no Entry object at that index.
    public func elements(withX xValue: Double) -> SubSequence {
        let match: (Element) -> Bool = { $0.x != xValue }
        let i = partitioningIndex(where: match)
        guard i < endIndex else { return self[endIndex...] }
        let lastIndex = self[i...].firstIndex(where: match) ?? endIndex
        return self[i..<lastIndex]
    }

    /// - Parameters:
    ///   - xValue: x-value of the element to search for
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: Rounding method if exact value was not found
    /// - Returns: The array-index of the specified element.
    /// If the no Entry at the specified x-value is found, this method returns the index of the Entry at the closest x-value according to the rounding.
    public func index(
        ofX xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding
    ) -> Index? {
        var closest = partitioningIndex { $0.x >= xValue }
        guard closest < endIndex else { return nil }

        let closestXValue = self[closest].x

        switch rounding {
        case .up:
            // If rounding up, and found x-value is lower than specified x, and we can go upper...
            if closestXValue < xValue, closest < index(before: endIndex) {
                formIndex(after: &closest)
            }

        case .down:
            // If rounding down, and found x-value is upper than specified x, and we can go lower...
            if closestXValue > xValue, closest > startIndex {
                formIndex(before: &closest)
            }

        case .closest:
            break
        }

        // Search by closest to y-value
        guard !yValue.isNaN else {
            return closest
        }

        while closest > startIndex, self[index(before: closest)].x == closestXValue {
            formIndex(before: &closest)
        }

        var closestYValue = self[closest].y
        var closestYIndex = closest

        while closest < index(before: endIndex) {
            formIndex(after: &closest)
            let value = self[closest]

            if value.x != closestXValue { break }
            if abs(value.y - yValue) <= abs(closestYValue - yValue) {
                closestYValue = yValue
                closestYIndex = closest
            }
        }

        closest = closestYIndex
        return closest
    }
}
