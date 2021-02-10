import CoreGraphics

typealias PieChartStyle = ChartStyle<PieChartDataEntry>

extension PieChartStyle {
    public enum ValuePosition {
        case insideSlice
        case outsideSlice
    }

    /// the space in pixels between the pie-slices
    /// **default**: 0
    /// **maximum**: 20
    public var sliceSpace: CGFloat {
        get { self[SliceSpaceChartStyleKey.self] }
        set { self[SliceSpaceChartStyleKey.self] = newValue.clamped(to: 0...20) }
    }

    /// When enabled, slice spacing will be 0.0 when the smallest value is going to be smaller than the slice spacing itself.
    public var automaticallyDisableSliceSpacing: Bool {
        get { self[AutoDisableSliceSpacingChartStyleKey.self] }
        set { self[AutoDisableSliceSpacingChartStyleKey.self] = newValue }
    }

    /// indicates the selection distance of a pie slice
    public var selectionShift: CGFloat {
        get { self[SelectionShiftChartStyleKey.self] }
        set { self[SelectionShiftChartStyleKey.self] = newValue }
    }

    public var xValuePosition: ValuePosition {
        get { self[XValuePositionChartStyleKey.self] }
        set { self[XValuePositionChartStyleKey.self] = newValue }
    }

    public var yValuePosition: ValuePosition {
        get { self[YValuePositionChartStyleKey.self] }
        set { self[YValuePositionChartStyleKey.self] = newValue }
    }

    /// When valuePosition is OutsideSlice, indicates line color
    public var valueLineColor: NSUIColor? {
        get { self[ValueLineColorChartStyleKey.self] }
        set { self[ValueLineColorChartStyleKey.self] = newValue }
    }

    /// When valuePosition is OutsideSlice and enabled, line will have the same color as the slice
    public var useValueColorForLine: Bool {
        get { self[UseValueColorForLineChartStyleKey.self] }
        set { self[UseValueColorForLineChartStyleKey.self] = newValue }
    }

    /// When valuePosition is OutsideSlice, indicates line width
    public var valueLineWidth: CGFloat {
        get { self[ValueLineWidthChartStyleKey.self] }
        set { self[ValueLineWidthChartStyleKey.self] = newValue }
    }

    /// When valuePosition is OutsideSlice, indicates offset as percentage out of the slice size
    public var valueLinePart1OffsetPercentage: CGFloat {
        get { self[ValueLinePart1OffsetPercentageChartStyleKey.self] }
        set { self[ValueLinePart1OffsetPercentageChartStyleKey.self] = newValue }
    }

    /// When valuePosition is OutsideSlice, indicates length of first half of the line
    public var valueLinePart1Length: CGFloat {
        get { self[ValueLinePart1LengthChartStyleKey.self] }
        set { self[ValueLinePart1LengthChartStyleKey.self] = newValue }
    }

    /// When valuePosition is OutsideSlice, indicates length of second half of the line
    public var valueLinePart2Length: CGFloat {
        get { self[ValueLinePart2LengthChartStyleKey.self] }
        set { self[ValueLinePart2LengthChartStyleKey.self] = newValue }
    }

    /// When valuePosition is OutsideSlice, this allows variable line length
    public var valueLineVariableLength: Bool {
        get { self[ValueLineVariableLengthChartStyleKey.self] }
        set { self[ValueLineVariableLengthChartStyleKey.self] = newValue }
    }

    /// the font for the slice-text labels
    public var entryLabelFont: NSUIFont? {
        get { self[EntryLabelFontChartStyleKey.self] }
        set { self[EntryLabelFontChartStyleKey.self] = newValue }
    }

    /// the color for the slice-text labels
    public var entryLabelColor: NSUIColor? {
        get { self[EntryLabelColorChartStyleKey.self] }
        set { self[EntryLabelColorChartStyleKey.self] = newValue }
    }
}

// MARK: - Keys

private enum SliceSpaceChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0
}

private enum AutoDisableSliceSpacingChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = false
}

private enum SelectionShiftChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 18
}

private enum XValuePositionChartStyleKey: ChartStyleKey {
    static let defaultValue: PieChartStyle.ValuePosition = .insideSlice
}

private enum YValuePositionChartStyleKey: ChartStyleKey {
    static let defaultValue: PieChartStyle.ValuePosition = .insideSlice
}

private enum ValueLineColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = .black
}

private enum UseValueColorForLineChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = false
}

private enum ValueLineWidthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 1
}

private enum ValueLinePart1OffsetPercentageChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.75
}

private enum ValueLinePart1LengthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.3
}

private enum ValueLinePart2LengthChartStyleKey: ChartStyleKey {
    static let defaultValue: CGFloat = 0.3
}

private enum ValueLineVariableLengthChartStyleKey: ChartStyleKey {
    static let defaultValue: Bool = true
}

private enum EntryLabelFontChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIFont? = nil
}

private enum EntryLabelColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor? = nil
}

private enum HighlightColorChartStyleKey: ChartStyleKey {
    static let defaultValue: NSUIColor = NSUIColor(red: 255.0 / 255.0, green: 187.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
}
