//
//  PieData.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

open class PieChartData: ChartData<PieChartDataEntry> {
    public required init() {
        super.init()
    }

    public init(dataSet: Element) {
        super.init(dataSets: [dataSet])
    }

    override public init(dataSets: [Element]) {
        super.init(dataSets: dataSets)
    }

    public required init(arrayLiteral elements: Element...) {
        super.init(dataSets: elements)
    }

    public var dataSet: PieChartDataSet? {
        get { first }
        set {
            if let set = newValue {
                _dataSets = [set]
            } else {
                _dataSets = []
            }
        }
    }

    /// - returns: All up to one dataSet object this ChartData object holds.
    override var _dataSets: [Element] {
        get {
            assert(super._dataSets.count <= 1, "Found multiple data sets while pie chart only allows one")
            return super._dataSets
        }
        set {
            super._dataSets = newValue
        }
    }

    override open func entry(for highlight: Highlight) -> PieChartDataEntry? {
        dataSet?[Int(highlight.x)]
    }

    /// The total y-value sum across all DataSet objects the this object represents.
    open var yValueSum: Double {
        guard let dataSet = dataSet else { return 0.0 }
        return dataSet.reduce(into: 0) {
            $0 += $1.y
        }
    }
}
