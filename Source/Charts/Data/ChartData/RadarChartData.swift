//
//  RadarChartData.swift
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

open class RadarChartData: ChartData {
    open var highlightColor = NSUIColor(red: 255.0 / 255.0, green: 187.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    open var highlightLineWidth = CGFloat(1.0)
    open var highlightLineDashPhase = CGFloat(0.0)
    open var highlightLineDashLengths: [CGFloat]?

    /// Sets labels that should be drawn around the RadarChart at the end of each web line.
    open var labels = [String]()

    /// Sets the labels that should be drawn around the RadarChart at the end of each web line.
    open func setLabels(_ labels: String...) {
        self.labels = labels
    }

    public required init() {
        super.init()
    }

    override public init(dataSets: [ChartDataSet]) {
        super.init(dataSets: dataSets)
    }

    public required init(arrayLiteral elements: ChartDataSet...) {
        super.init(dataSets: elements)
    }

    override open func entry(for highlight: Highlight) -> ChartDataEntry? {
        self[highlight.dataSetIndex][Int(highlight.x)]
    }
}
