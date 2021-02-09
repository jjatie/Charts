//
//  ChartLimitLine.swift
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

/// The limit line is an additional feature for all Line, Bar and ScatterCharts.
/// It allows the displaying of an additional line in the chart that marks a certain maximum / limit on the specified axis (x- or y-axis).
public struct ChartLimitLine: Component, Equatable {
    public enum LabelPosition: Equatable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    public var isEnabled = true

    public var xOffset: CGFloat = 5

    public var yOffset: CGFloat = 5

    /// limit / maximum (the y-value or xIndex)
    public var limit: Double

    public var lineColor = NSUIColor(red: 237.0 / 255.0, green: 91.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0)
    public var lineDashPhase: CGFloat = 0.0
    public var lineDashLengths: [CGFloat]?

    public var valueTextColor = NSUIColor.labelOrBlack
    public var valueFont = NSUIFont.systemFont(ofSize: 13.0)

    public var drawLabelEnabled = true
    public var label: String
    public var labelPosition = LabelPosition.topRight

    public init(limit: Double, label: String = "") {
        self.limit = limit
        self.label = label
    }

    /// set the line width of the chart (min = 0.2, max = 12); default 2
    public var lineWidth: CGFloat {
        get { _lineWidth }
        set { _lineWidth = newValue.clamped(to: 0.2 ... 12) }
    }
    private var _lineWidth = CGFloat(2.0)
}
