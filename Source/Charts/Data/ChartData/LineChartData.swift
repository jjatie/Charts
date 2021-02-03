//
//  LineChartData.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

/// Data object that encapsulates all data associated with a LineChart.
open class LineChartData: ChartData<ChartDataEntry> {
    public required init() {
        super.init()
    }

    override public init(dataSets: [Element]) {
        super.init(dataSets: dataSets)
    }

    public required init(arrayLiteral elements: Element...) {
        super.init(dataSets: elements)
    }
}
