//
//  BarChartDataSet.swift
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

open class BarChartDataSet: BarLineScatterCandleBubbleChartDataSet, BarChartDataSetProtocol {
    private func initialize() {
        highlightColor = NSUIColor.black

        calcStackSize(entries: entries as! [BarChartDataEntry])
        calcEntryCountIncludingStacks(entries: entries as! [BarChartDataEntry])
    }

    public required init() {
        super.init()
        initialize()
    }

    override public init(entries: [ChartDataEntry], label: String = "DataSet") {
        super.init(entries: entries, label: label)
        initialize()
    }

    // MARK: - Data functions and accessors

    /// the maximum number of bars that are stacked upon each other, this value
    /// is calculated from the Entries that are added to the DataSet
    public private(set) var stackSize = 1

    /// the overall entry count, including counting each stack-value individually
    public private(set) var entryCountStacks = 0

    /// Calculates the total number of entries this DataSet represents, including
    /// stacks. All values belonging to a stack are calculated separately.
    private func calcEntryCountIncludingStacks(entries: [BarChartDataEntry]) {
        entryCountStacks = entries.lazy
            .map(\.stackSize)
            .reduce(into: 0, +=)
    }

    /// calculates the maximum stacksize that occurs in the Entries array of this DataSet
    private func calcStackSize(entries: [BarChartDataEntry]) {
        stackSize = entries.lazy
            .map(\.stackSize)
            .max() ?? 1
    }

    override open func calcMinMax(entry e: ChartDataEntry) {
        guard let e = e as? BarChartDataEntry,
              !e.y.isNaN
        else { return }

        if e.yValues == nil {
            yRange = merge(yRange, e.y)
        } else {
            yRange = merge(yRange, (-e.negativeSum, e.positiveSum))
        }

        calcMinMaxX(entry: e)
    }

    /// `true` if this DataSet is stacked (stacksize > 1) or not.
    public var isStacked: Bool {
        stackSize > 1
    }

    /// array of labels used to describe the different values of the stacked bars
    open var stackLabels: [String] = []

    // MARK: - Styling functions and accessors

    /// the color used for drawing the bar-shadows. The bar shadows is a surface behind the bar that indicates the maximum value
    open var barShadowColor = NSUIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)

    /// the width used for drawing borders around the bars. If borderWidth == 0, no border will be drawn.
    open var barBorderWidth: CGFloat = 0.0

    /// the color drawing borders around the bars.
    open var barBorderColor = NSUIColor.black

    /// the alpha value (transparency) that is used for drawing the highlight indicator bar. min = 0.0 (fully transparent), max = 1.0 (fully opaque)
    open var highlightAlpha = CGFloat(120.0 / 255.0)

    // MARK: - NSCopying

    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! BarChartDataSet
        copy.stackSize = stackSize
        copy.entryCountStacks = entryCountStacks
        copy.stackLabels = stackLabels

        copy.barShadowColor = barShadowColor
        copy.barBorderWidth = barBorderWidth
        copy.barBorderColor = barBorderColor
        copy.highlightAlpha = highlightAlpha
        return copy
    }
}
