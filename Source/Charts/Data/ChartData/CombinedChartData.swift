//
//  CombinedChartData.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

open class CombinedChartData: BarLineScatterCandleBubbleChartData {
    private var _lineData: LineChartData!
    private var _barData: BarChartData!
    private var _scatterData: ScatterChartData!
    private var _candleData: CandleChartData!
    private var _bubbleData: BubbleChartData!

    public required init() {
        super.init()
    }

    override public init(dataSets: [ChartDataSet]) {
        super.init(dataSets: dataSets)
    }

    public required init(arrayLiteral elements: ChartDataSet...) {
        super.init(dataSets: elements)
    }

    open var lineData: LineChartData! {
        get {
            return _lineData
        }
        set {
            _lineData = newValue
            notifyDataChanged()
        }
    }

    open var barData: BarChartData! {
        get {
            return _barData
        }
        set {
            _barData = newValue
            notifyDataChanged()
        }
    }

    open var scatterData: ScatterChartData! {
        get {
            return _scatterData
        }
        set {
            _scatterData = newValue
            notifyDataChanged()
        }
    }

    open var candleData: CandleChartData! {
        get {
            return _candleData
        }
        set {
            _candleData = newValue
            notifyDataChanged()
        }
    }

    open var bubbleData: BubbleChartData! {
        get {
            return _bubbleData
        }
        set {
            _bubbleData = newValue
            notifyDataChanged()
        }
    }

    override open func calcMinMax() {
        _dataSets.removeAll()

        for data in allData {
            data.calcMinMax()

            _dataSets.append(contentsOf: data)

            xRange = merge(xRange, data.xRange)

            for set in data {
                if set.axisDependency == .left {
                    leftAxisRange = merge(leftAxisRange, set.yRange)
                } else {
                    rightAxisRange = merge(rightAxisRange, set.yRange)
                }
            }
        }
    }

    /// All data objects in row: line-bar-scatter-candle-bubble if not null.
    open var allData: [ChartData] {
        var data = [ChartData]()

        if lineData !== nil {
            data.append(lineData)
        }
        if barData !== nil {
            data.append(barData)
        }
        if scatterData !== nil {
            data.append(scatterData)
        }
        if candleData !== nil {
            data.append(candleData)
        }
        if bubbleData !== nil {
            data.append(bubbleData)
        }

        return data
    }

    open func dataByIndex(_ index: Int) -> ChartData {
        return allData[index]
    }

    open func dataIndex(_ data: ChartData) -> Int? {
        return allData.firstIndex { $0 === data }
    }

    override open func removeEntry(_: ChartDataEntry, dataSetIndex _: Int) -> Bool {
        print("removeEntry(entry, dataSetIndex) not supported for CombinedData", terminator: "\n")
        return false
    }

    public override func notifyDataChanged() {
        calcMinMax() // recalculate everything
    }

    /// Get the Entry for a corresponding highlight object
    ///
    /// - Parameters:
    ///   - highlight:
    /// - Returns: The entry that is highlighted
    override open func entry(for highlight: Highlight) -> ChartDataEntry? {
        // The value of the highlighted entry could be NaN - if we are not interested in highlighting a specific value.
        getDataSetByHighlight(highlight)?
            .elements(withX: highlight.x)
            .first { $0.y == highlight.y || highlight.y.isNaN }
    }

    /// Get dataset for highlight
    ///
    /// - Parameters:
    ///   - highlight: current highlight
    /// - Returns: dataset related to highlight
    open func getDataSetByHighlight(_ highlight: Highlight) -> ChartDataSet! {
        guard allData.indices.contains(highlight.dataIndex) else {
            return nil
        }

        let data = dataByIndex(highlight.dataIndex)

        guard data.indices.contains(highlight.dataSetIndex) else {
            return nil
        }

        // The value of the highlighted entry could be NaN - if we are not interested in highlighting a specific value.
        return data[highlight.dataSetIndex]
    }

    // MARK: Unsupported Collection Methods

    // TODO:
//    public override func append(_ newElement: ChartData.Element) {
//        fatalError("append(_:) not supported for CombinedData")
//    }
//
//    public override func remove(at i: Int) -> ChartDataSet {
//        fatalError("remove(at:) not supported for CombinedData")
//    }
}
