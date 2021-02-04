//
//  PieChartDataSet.swift
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

public class PieChartDataSet: ChartDataSet, PieChartDataSetProtocol {
    public enum ValuePosition {
        case insideSlice
        case outsideSlice
    }

    private func initialize() {
        style.valueTextColor = NSUIColor.white
        style.valueFont = NSUIFont.systemFont(ofSize: 13.0)
    }

    public required init() {
        super.init()
        initialize()
    }

    override public init(entries: [ChartDataEntry], label: String) {
        super.init(entries: entries, label: label)
        initialize()
    }

    override func calcMinMax(entry e: ChartDataEntry) {
        calcMinMaxY(entry: e)
    }

    // MARK: - Styling functions and accessors

    /// the space in pixels between the pie-slices
    /// **default**: 0
    /// **maximum**: 20
    public var sliceSpace: CGFloat {
        get { _sliceSpace }
        set { _sliceSpace = newValue.clamped(to: 0...20) }
    }
    private var _sliceSpace = CGFloat(0.0)

    /// When enabled, slice spacing will be 0.0 when the smallest value is going to be smaller than the slice spacing itself.
    public var automaticallyDisableSliceSpacing: Bool = false

    /// indicates the selection distance of a pie slice
    public var selectionShift = CGFloat(18.0)

    public var xValuePosition: ValuePosition = .insideSlice
    public var yValuePosition: ValuePosition = .insideSlice

    /// When valuePosition is OutsideSlice, indicates line color
    public var valueLineColor: NSUIColor? = NSUIColor.black

    /// When valuePosition is OutsideSlice and enabled, line will have the same color as the slice
    public var useValueColorForLine: Bool = false

    /// When valuePosition is OutsideSlice, indicates line width
    public var valueLineWidth: CGFloat = 1.0

    /// When valuePosition is OutsideSlice, indicates offset as percentage out of the slice size
    public var valueLinePart1OffsetPercentage: CGFloat = 0.75

    /// When valuePosition is OutsideSlice, indicates length of first half of the line
    public var valueLinePart1Length: CGFloat = 0.3

    /// When valuePosition is OutsideSlice, indicates length of second half of the line
    public var valueLinePart2Length: CGFloat = 0.4

    /// When valuePosition is OutsideSlice, this allows variable line length
    public var valueLineVariableLength: Bool = true

    /// the font for the slice-text labels
    public var entryLabelFont: NSUIFont?

    /// the color for the slice-text labels
    public var entryLabelColor: NSUIColor?

    /// the color for the highlighted sector
    public var highlightColor: NSUIColor?

    // MARK: - NSCopying

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PieChartDataSet
        copy._sliceSpace = _sliceSpace
        copy.automaticallyDisableSliceSpacing = automaticallyDisableSliceSpacing
        copy.selectionShift = selectionShift
        copy.xValuePosition = xValuePosition
        copy.yValuePosition = yValuePosition
        copy.valueLineColor = valueLineColor
        copy.valueLineWidth = valueLineWidth
        copy.valueLinePart1OffsetPercentage = valueLinePart1OffsetPercentage
        copy.valueLinePart1Length = valueLinePart1Length
        copy.valueLinePart2Length = valueLinePart2Length
        copy.valueLineVariableLength = valueLineVariableLength
        copy.entryLabelFont = entryLabelFont
        copy.entryLabelColor = entryLabelColor
        copy.highlightColor = highlightColor
        return copy
    }
}
