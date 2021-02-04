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

public protocol ChartDataSetProtocol: AnyObject, RandomAccessCollection, MutableCollection {
    // MARK: - Data functions and accessors

    /// Use this method to tell the data set that the underlying data has changed
    func notifyDataSetChanged()

    /// Calculates the minimum and maximum x and y values (xMin, xMax, yMin, yMax).
    func calcMinMax()

    /// Calculates the min and max y-values from the Entry closest to the given fromX to the Entry closest to the given toX value.
    /// This is only needed for the autoScaleMinMax feature.
    func calcMinMaxY(fromX: Double, toX: Double)

    /// The minimum y-value this DataSet holds
    var yMin: Double { get }

    /// The maximum y-value this DataSet holds
    var yMax: Double { get }

    /// The minimum x-value this DataSet holds
    var xMin: Double { get }

    /// The maximum x-value this DataSet holds
    var xMax: Double { get }

    /// - Parameters:
    ///   - xValue: the x-value
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: determine whether to round up/down/closest if there is no Entry matching the provided x-value
    /// - Returns: The first Entry object found at the given x-value with binary search.
    /// If the no Entry at the specified x-value is found, this method returns the Entry at the closest x-value according to the rounding.
    /// nil if no Entry object at that x-value.
    func entryForXValue(
        _ xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding
    ) -> ChartDataEntry?

    /// - Parameters:
    ///   - xValue: the x-value
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    /// - Returns: The first Entry object found at the given x-value with binary search.
    /// If the no Entry at the specified x-value is found, this method returns the Entry at the closest x-value.
    /// nil if no Entry object at that x-value.
    func entryForXValue(
        _ xValue: Double,
        closestToY yValue: Double
    ) -> ChartDataEntry?

    /// - Returns: All Entry objects found at the given x-value with binary search.
    /// An empty array if no Entry object at that x-value.
    func entriesForXValue(_ xValue: Double) -> [ChartDataEntry]

    /// - Parameters:
    ///   - xValue: x-value of the entry to search for
    ///   - closestToY: If there are multiple y-values for the specified x-value,
    ///   - rounding: Rounding method if exact value was not found
    /// - Returns: The array-index of the specified entry.
    /// If the no Entry at the specified x-value is found, this method returns the index of the Entry at the closest x-value according to the rounding.
    func entryIndex(
        x xValue: Double,
        closestToY yValue: Double,
        rounding: ChartDataSetRounding
    ) -> Int

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
    func addEntryOrdered(_ e: ChartDataEntry)

    /// Removes an Entry from the DataSet dynamically.
    ///
    /// *optional feature, can return `false` ifnot implemented*
    ///
    /// - Parameters:
    ///   - entry: the entry to remove
    /// - Returns: `true` if the entry was removed successfully, `false` ifthe entry does not exist or if this feature is not supported
    func remove(_ entry: ChartDataEntry) -> Bool

    /// Removes the Entry object closest to the given x-value from the DataSet.
    ///
    /// *optional feature, can return `false` ifnot implemented*
    ///
    /// - Parameters:
    ///   - x: the x-value to remove
    /// - Returns: `true` if the entry was removed successfully, `false` ifthe entry does not exist or if this feature is not supported
    func removeEntry(x: Double) -> Bool

    // MARK: - Styling functions and accessors

    /// The label string that describes the DataSet.
    var label: String? { get }

    /// The axis this DataSet should be plotted against.
    var axisDependency: YAxis.AxisDependency { get }

//    /// List representing all colors that are used for drawing the actual values for this DataSet
//    var valueColors: [NSUIColor] { get }
//
//    /// All the colors that are used for this DataSet.
//    /// Colors are reused as soon as the number of Entries the DataSet represents is higher than the size of the colors array.
//    var colors: [NSUIColor] { get }
//
    /// - Returns: The color at the given index of the DataSet's color array.
    /// This prevents out-of-bounds by performing a modulus on the color index, so colours will repeat themselves.
    func color(at: Int) -> NSUIColor
//
//    func resetColors()
//
    func addColor(_ color: NSUIColor)

    func setColor(_ color: NSUIColor)
//
//    /// if true, value highlighting is enabled
//    var isHighlightEnabled: Bool { get set }
//
//    /// Custom formatter that is used instead of the auto-formatter if set
//    var valueFormatter: ValueFormatter { get set }
//
//    /// Sets/get a single color for value text.
//    /// Setting the color clears the colors array and adds a single color.
//    /// Getting will return the first color in the array.
//    var valueTextColor: NSUIColor { get set }
//
//    /// - Returns: The color at the specified index that is used for drawing the values inside the chart. Uses modulus internally.
//    func valueTextColorAt(_ index: Int) -> NSUIColor
//
//    /// the font for the value-text labels
//    var valueFont: NSUIFont { get set }
//
//    /// The rotation angle (in degrees) for value-text labels
//    var valueLabelAngle: CGFloat { get set }
//
//    /// The form to draw for this dataset in the legend.
//    ///
//    /// Return `.Default` to use the default legend form.
//    var form: Legend.Form { get }
//
//    /// The form size to draw for this dataset in the legend.
//    ///
//    /// Return `NaN` to use the default legend form size.
//    var formSize: CGFloat { get }
//
//    /// The line width for drawing the form of this dataset in the legend
//    ///
//    /// Return `NaN` to use the default legend form line width.
//    var formLineWidth: CGFloat { get }
//
//    /// Line dash configuration for legend shapes that consist of lines.
//    ///
//    /// This is how much (in pixels) into the dash pattern are we starting from.
//    var formLineDashPhase: CGFloat { get }
//
//    /// Line dash configuration for legend shapes that consist of lines.
//    ///
//    /// This is the actual dash pattern.
//    /// I.e. [2, 3] will paint [--   --   ]
//    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
//    var formLineDashLengths: [CGFloat]? { get }
//
//    /// Set this to true to draw y-values on the chart.
//    ///
//    /// - Note: For bar and line charts: if `maxVisibleCount` is reached, no values will be drawn even if this is enabled.
//    var isDrawValuesEnabled: Bool { get set }
//
//    /// Set this to true to draw y-icons on the chart
//    ///
//    /// - Note: For bar and line charts: if `maxVisibleCount` is reached, no icons will be drawn even if this is enabled.
//    var isDrawIconsEnabled: Bool { get set }
//
//    /// Offset of icons drawn on the chart.
//    ///
//    /// For all charts except Pie and Radar it will be ordinary (x offset, y offset).
//    ///
//    /// For Pie and Radar chart it will be (y offset, distance from center offset); so if you want icon to be rendered under value, you should increase X component of CGPoint, and if you want icon to be rendered closet to center, you should decrease height component of CGPoint.
//    var iconsOffset: CGPoint { get set }
//
//    /// `true` if this DataSet is visible inside the chart, or `false` ifit is currently hidden.
//    var isVisible: Bool { get set }
}
