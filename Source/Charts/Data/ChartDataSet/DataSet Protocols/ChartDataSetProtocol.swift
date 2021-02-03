//
//  ChartDataSetProtocol.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import CoreGraphics
import Foundation

public protocol ChartDataSetProtocol: RandomAccessCollection, MutableCollection {
    // MARK: - Data functions and accessors

    /// Use this method to tell the data set that the underlying data has changed
    func notifyDataSetChanged()

    /// Calculates the minimum and maximum x and y values (xMin, xMax, yMin, yMax).
    func calcMinMax()

    /// Calculates the min and max y-values from the Entry closest to the given fromX to the Entry closest to the given toX value.
    /// This is only needed for the autoScaleMinMax feature.
    func calcMinMaxY(fromX: Double, toX: Double)

    var xRange: AxisRange { get }
    var yRange: AxisRange { get }

    /// - Parameters:
    ///   - xValue: the x-value
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: determine whether to round up/down/closest if there is no Entry matching the provided x-value
    /// - Returns: The first Entry object found at the given x-value with binary search.
    /// If the no Entry at the specified x-value is found, this method returns the Entry at the closest x-value according to the rounding.
    /// nil if no Entry object at that x-value.
    func element(
        withX xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding
    ) -> Element?

    /// - Returns: All Entry objects found at the given x-value with binary search.
    /// An empty array if no Entry object at that x-value.
    func elements(withX xValue: Double) -> SubSequence

    /// - Parameters:
    ///   - xValue: x-value of the entry to search for
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: Rounding method if exact value was not found
    /// - Returns: The array-index of the specified entry.
    /// If the no Entry at the specified x-value is found, this method returns the index of the Entry at the closest x-value according to the rounding.
    func index(
        ofX xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding
    ) -> Index?

    /// Adds an Entry to the DataSet dynamically.
    /// Entries are added to their appropriate index in the values array respective to their x-position.
    /// This will also recalculate the current minimum and maximum values of the DataSet and the value-sum.
    ///
    /// *optional feature, can return `false` ifnot implemented*
    ///
    /// Entries are added to the end of the list.
    ///
    /// - Parameters:
    ///   - e: the entry to add
    func addEntryOrdered(_ e: Element)

    /// Removes an Entry from the DataSet dynamically.
    ///
    /// *optional feature, can return `false` ifnot implemented*
    ///
    /// - Parameters:
    ///   - entry: the entry to remove
    /// - Returns: `true` if the entry was removed successfully, `false` ifthe entry does not exist or if this feature is not supported
    func remove(_ entry: Element) -> Bool

    // MARK: - Styling functions and accessors

    /// The label string that describes the DataSet.
    var label: String? { get }

    /// The axis this DataSet should be plotted against.
    var axisDependency: YAxis.AxisDependency { get }
}

extension ChartDataSetProtocol {
    /// Use this method to tell the data set that the underlying data has changed
    public func notifyDataSetChanged() {
        calcMinMax()
    }

    @discardableResult
    public func removeEntry(x: Double) -> Bool {
        if let entry = entryForXValue(x, closestToY: Double.nan) {
            return remove(entry)
        }
        return false
    }
}
