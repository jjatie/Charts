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

/// The DataSet class represents one group or type of entries (Entry) in the Chart that belong together.
/// It is designed to logically separate different groups of values inside the Chart (e.g. the values for a specific line in the LineChart, or the values of a specific group of bars in the BarChart).
@dynamicMemberLookup
open class ChartDataSet: ChartDataSetProtocol, NSCopying {
    /// - Note: Calls `notifyDataSetChanged()` after setting a new value.
    /// - Returns: The array of y-values that this DataSet represents.
    /// the entries that this dataset represents / holds together
    open private(set) var entries: [ChartDataEntry]

    /// The label string that describes the DataSet.
    open var label: String? = "DataSet"

    open var style = ChartStyle<Element>()

    /// The axis this DataSet should be plotted against.
    open var axisDependency = YAxis.AxisDependency.left

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<ChartStyle<Element>, T>) -> T {
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

    open func calcMinMax() {
        yMax = -Double.greatestFiniteMagnitude
        yMin = Double.greatestFiniteMagnitude
        xMax = -Double.greatestFiniteMagnitude
        xMin = Double.greatestFiniteMagnitude

        guard !isEmpty else { return }

        forEach(calcMinMax)
    }

    open func calcMinMaxY(fromX: Double, toX: Double) {
        yMax = -Double.greatestFiniteMagnitude
        yMin = Double.greatestFiniteMagnitude

        guard !isEmpty else { return }

        let indexFrom = entryIndex(x: fromX, closestToY: .nan, rounding: .down)
        let indexTo = entryIndex(x: toX, closestToY: .nan, rounding: .up)

        guard indexTo >= indexFrom else { return }
        // only recalculate y
        self[indexFrom ... indexTo].forEach(calcMinMaxY)
    }

    open func calcMinMaxX(entry e: ChartDataEntry) {
        xMin = Swift.min(e.x, xMin)
        xMax = Swift.max(e.x, xMax)
    }

    open func calcMinMaxY(entry e: ChartDataEntry) {
        yMin = Swift.min(e.y, yMin)
        yMax = Swift.max(e.y, yMax)
    }

    /// Updates the min and max x and y value of this DataSet based on the given Entry.
    ///
    /// - Parameters:
    ///   - e:
    internal func calcMinMax(entry e: ChartDataEntry) {
        calcMinMaxX(entry: e)
        calcMinMaxY(entry: e)
    }

    /// The minimum y-value this DataSet holds
    public internal(set) var yMin: Double = Double.greatestFiniteMagnitude

    /// The maximum y-value this DataSet holds
    public internal(set) var yMax: Double = -Double.greatestFiniteMagnitude

    /// The minimum x-value this DataSet holds
    public internal(set) var xMin: Double = Double.greatestFiniteMagnitude

    /// The maximum x-value this DataSet holds
    public internal(set) var xMax: Double = -Double.greatestFiniteMagnitude

    /// - Parameters:
    ///   - xValue: the x-value
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: determine whether to round up/down/closest if there is no Entry matching the provided x-value
    /// - Returns: The first Entry object found at the given x-value with binary search.
    /// If the no Entry at the specified x-value is found, this method returns the Entry at the closest x-value according to the rounding.
    /// nil if no Entry object at that x-value.
    public func entryForXValue(
        _ xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding
    ) -> ChartDataEntry? {
        let index = entryIndex(x: xValue, closestToY: yValue, rounding: rounding)
        if index > -1 {
            return self[index]
        }
        return nil
    }

    /// - Parameters:
    ///   - xValue: the x-value
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    /// - Returns: The first Entry object found at the given x-value with binary search.
    /// If the no Entry at the specified x-value is found, this method returns the Entry at the closest x-value.
    /// nil if no Entry object at that x-value.
    public func entryForXValue(
        _ xValue: Double,
        closestToY yValue: Double
    ) -> ChartDataEntry? {
        entryForXValue(xValue, closestToY: yValue, rounding: .closest)
    }

    /// - Returns: All Entry objects found at the given xIndex with binary search.
    /// An empty array if no Entry object at that index.
    public func entriesForXValue(_ xValue: Double) -> [ChartDataEntry] {
        let match: (ChartDataEntry) -> Bool = { $0.x == xValue }
        let i = partitioningIndex(where: match)
        guard i < endIndex else { return [] }
        return self[i...].prefix(while: match)
    }

    /// - Parameters:
    ///   - xValue: x-value of the entry to search for
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: Rounding method if exact value was not found
    /// - Returns: The array-index of the specified entry.
    /// If the no Entry at the specified x-value is found, this method returns the index of the Entry at the closest x-value according to the rounding.
    public func entryIndex(
        x xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding
    ) -> Int {
        var closest = partitioningIndex { $0.x >= xValue }
        guard closest < endIndex else { return closest }

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

        guard closest < endIndex else { return endIndex }

        // Search by closest to y-value
        if !yValue.isNaN {
            while closest > startIndex, self[index(before: closest)].x == closestXValue {
                formIndex(before: &closest)
            }

            var closestYValue = self[closest].y
            var closestYIndex = closest

            while closest < endIndex - 1 {
                formIndex(after: &closest)
                let value = self[closest]

                if value.x != closestXValue { break }
                if abs(value.y - yValue) <= abs(closestYValue - yValue) {
                    closestYValue = yValue
                    closestYIndex = closest
                }
            }

            closest = closestYIndex
        }

        return closest
    }

    /// Adds an Entry to the DataSet dynamically.
    /// Entries are added to their appropriate index respective to it's x-index.
    /// This will also recalculate the current minimum and maximum values of the DataSet and the value-sum.
    ///
    /// - Parameters:
    ///   - e: the entry to add
    public func addEntryOrdered(_ e: ChartDataEntry) {
        if let last = last, last.x > e.x {
            let startIndex = entryIndex(x: e.x, closestToY: e.y, rounding: .up)
            let closestIndex = self[startIndex...].lastIndex { $0.x < e.x }
                ?? startIndex
            calcMinMax(entry: e)
            entries.insert(e, at: closestIndex)
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
    open func remove(_ entry: ChartDataEntry) -> Bool {
        guard let index = firstIndex(of: entry) else { return false }
        _ = remove(at: index)
        return true
    }

    // MARK: - NSCopying

    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = type(of: self).init()

        copy.entries = entries
        copy.label = label
        copy.axisDependency = axisDependency
        copy.yMax = yMax
        copy.yMin = yMin
        copy.xMax = xMax
        copy.xMin = xMin

        return copy
    }
}

// MARK: - Styling functions and accessors

extension ChartDataSet {
    open func color(atIndex index: Int) -> NSUIColor {
        style.colors[index % style.colors.count]
    }

    open func valueTextColorAt(_ index: Int) -> NSUIColor {
        style.valueColors[index % style.valueColors.count]
    }

    open func addColor(_ color: NSUIColor) {
        style.colors.append(color)
    }

    open func setColor(_ color: NSUIColor) {
        style.colors.removeAll(keepingCapacity: false)
        style.colors.append(color)
    }

    open func setColor(_ color: NSUIColor, alpha: CGFloat) {
        setColor(color.withAlphaComponent(alpha))
    }

    open func setColors(_ colors: [NSUIColor], alpha: CGFloat) {
        self.style.colors = colors.map { $0.withAlphaComponent(alpha) }
    }

    open func setColors(_ colors: NSUIColor...) {
        self.style.colors = colors
    }
}

extension NSUIColor {
    static var defaultDataSet: Self {
        Self(red: 140.0 / 255.0, green: 234.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
}
public struct ChartStyle<EntryType: ChartDataEntry> {
    public init() { }

    /// All the colors that are used for this DataSet.
    /// Colors are reused as soon as the number of Entries the DataSet represents is higher than the size of the colors array.
    public var colors: [NSUIColor] = [.defaultDataSet]

    /// List representing all colors that are used for drawing the actual values for this DataSet
    public var valueColors: [NSUIColor] = [.labelOrBlack]

    /// `true` if value highlighting is enabled for this dataset
    public var isHighlightEnabled: Bool = true

    /// Custom formatter that is used instead of the auto-formatter if set
    public var valueFormatter: ValueFormatter = DefaultValueFormatter()

    /// Sets/get a single color for value text.
    /// Setting the color clears the colors array and adds a single color.
    /// Getting will return the first color in the array.
    public var valueTextColor: NSUIColor {
        get { valueColors[0] }
        set {
            valueColors.removeAll(keepingCapacity: false)
            valueColors.append(newValue)
        }
    }

    /// the font for the value-text labels
    public var valueFont = NSUIFont.systemFont(ofSize: 7.0)

    /// The rotation angle (in degrees) for value-text labels
    public var valueLabelAngle = CGFloat(0.0)

    /// The form to draw for this dataset in the legend.
    public var form = Legend.Form.default

    /// The form size to draw for this dataset in the legend.
    ///
    /// Return `NaN` to use the default legend form size.
    public var formSize = CGFloat.nan

    /// The line width for drawing the form of this dataset in the legend
    ///
    /// Return `NaN` to use the default legend form line width.
    public var formLineWidth = CGFloat.nan

    /// Line dash configuration for legend shapes that consist of lines.
    ///
    /// This is how much (in pixels) into the dash pattern are we starting from.
    public var formLineDashPhase: CGFloat = 0.0

    /// Line dash configuration for legend shapes that consist of lines.
    ///
    /// This is the actual dash pattern.
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    public var formLineDashLengths: [CGFloat]?

    public var isDrawValuesEnabled: Bool = true

    public var isDrawIconsEnabled: Bool = true

    /// Offset of icons drawn on the chart.
    ///
    /// For all charts except Pie and Radar it will be ordinary (x offset, y offset).
    ///
    /// For Pie and Radar chart it will be (y offset, distance from center offset); so if you want icon to be rendered under value, you should increase X component of CGPoint, and if you want icon to be rendered closet to center, you should decrease height component of CGPoint.
    public var iconsOffset = CGPoint(x: 0, y: 0)

    public var isVisible: Bool = true
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

    open var count: Int {
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
    open var description: String {
        String(format: "%@, label: %@, %i entries", arguments: [NSStringFromClass(type(of: self)), self.label ?? "", self.count])
    }
}

// MARK: - CustomDebugStringConvertible
extension ChartDataSet: CustomDebugStringConvertible {
    open var debugDescription: String {
        reduce(into: description + ":") {
            $0 += "\n\($1.description)"
        }
    }
}
