//
//  LineChartDataSet.swift
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

public class LineChartDataSet: LineRadarChartDataSet, LineChartDataSetProtocol {
    public enum Mode {
        case linear
        case stepped
        case cubicBezier
        case horizontalBezier
    }

    private func initialize() {
        // default color
        circleColors.append(.defaultDataSet)
    }

    public required init() {
        super.init()
        initialize()
    }

    override public init(entries: [ChartDataEntry], label: String) {
        super.init(entries: entries, label: label)
        initialize()
    }

    // MARK: - Data functions and accessors

    // MARK: - Styling functions and accessors

    /// The drawing mode for this line dataset
    ///
    /// **default**: Linear
    public var mode = Mode.linear

    /// Intensity for cubic lines (min = 0.05, max = 1)
    ///
    /// **default**: 0.2
    public var cubicIntensity: CGFloat {
        get { _cubicIntensity }
        set { _cubicIntensity = newValue.clamped(to: 0.05 ... 1) }
    }
    private var _cubicIntensity = CGFloat(0.2)

    public var isDrawLineWithGradientEnabled = false

    public var gradientPositions: [CGFloat]?

    /// The radius of the drawn circles.
    public var circleRadius = CGFloat(8.0)

    /// The hole radius of the drawn circles
    public var circleHoleRadius = CGFloat(4.0)

    public var circleColors = [NSUIColor]()

    /// - Returns: The color at the given index of the DataSet's circle-color array.
    /// Performs a IndexOutOfBounds check by modulus.
    public func getCircleColor(at index: Int) -> NSUIColor? {
        let size = circleColors.count
        let index = index % size
        if index >= size {
            return nil
        }
        return circleColors[index]
    }

    /// Sets the one and ONLY color that should be used for this DataSet.
    /// Internally, this recreates the colors array and adds the specified color.
    public func setCircleColor(_ color: NSUIColor) {
        circleColors.removeAll(keepingCapacity: false)
        circleColors.append(color)
    }

    public func setCircleColors(_ colors: NSUIColor...) {
        circleColors.removeAll(keepingCapacity: false)
        circleColors.append(contentsOf: colors)
    }

    /// Resets the circle-colors array and creates a new one
    public func resetCircleColors(_: Int) {
        circleColors.removeAll(keepingCapacity: false)
    }

    /// If true, drawing circles is enabled
    public var isDrawCirclesEnabled = true

    /// The color of the inner circle (the circle-hole).
    public var circleHoleColor: NSUIColor? = NSUIColor.white

    /// `true` if drawing the circle-holes is enabled, `false` ifnot.
    public var isDrawCircleHoleEnabled = true

    /// This is how much (in pixels) into the dash pattern are we starting from.
    public var lineDashPhase: CGFloat = 0

    /// This is the actual dash pattern.
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    public var lineDashLengths: [CGFloat]?

    /// Line cap type, default is CGLineCap.Butt
    public var lineCapType: CGLineCap = .butt

    /// formatter for customizing the position of the fill-line

    /// Sets a custom FillFormatterProtocol to the chart that handles the position of the filled-line for each DataSet. Set this to null to use the default logic.
    public var fillFormatter: FillFormatter = DefaultFillFormatter()

    // MARK: NSCopying

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! LineChartDataSet
        copy.circleColors = circleColors
        copy.circleHoleColor = circleHoleColor
        copy.circleRadius = circleRadius
        copy.circleHoleRadius = circleHoleRadius
        copy.cubicIntensity = cubicIntensity
        copy.lineDashPhase = lineDashPhase
        copy.lineDashLengths = lineDashLengths
        copy.lineCapType = lineCapType
        copy.isDrawCirclesEnabled = isDrawCirclesEnabled
        copy.isDrawCircleHoleEnabled = isDrawCircleHoleEnabled
        copy.mode = mode
        copy.fillFormatter = fillFormatter
        return copy
    }
}
