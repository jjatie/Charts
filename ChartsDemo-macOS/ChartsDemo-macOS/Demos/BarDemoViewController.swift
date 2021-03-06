//
//  BarDemoViewController.swift
//  ChartsDemo-OSX
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts

import Charts
import Cocoa
import Foundation

open class BarDemoViewController: NSViewController {
    @IBOutlet var barChartView: BarChartView!

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let xArray = Array(1 ..< 10)
        let ys1 = xArray.map { x in sin(Double(x) / 2.0 / 3.141 * 1.5) }
        let ys2 = xArray.map { x in cos(Double(x) / 2.0 / 3.141) }

        let yse1 = ys1.enumerated().map { x, y in BarChartDataEntry(x: Double(x), y: y) }
        let yse2 = ys2.enumerated().map { x, y in BarChartDataEntry(x: Double(x), y: y) }

        let data = BarChartData()
        let ds1 = BarChartDataSet(entries: yse1, label: "Hello")
        ds1.colors = [NSUIColor.red]
        data.append(ds1)

        let ds2 = BarChartDataSet(entries: yse2, label: "World")
        ds2.colors = [NSUIColor.blue]
        data.append(ds2)

        let barWidth = 0.4
        let barSpace = 0.05
        let groupSpace = 0.1

        data.barWidth = barWidth
        barChartView.xAxis.axisMinimum = Double(xArray[0])
        barChartView.xAxis.axisMaximum = Double(xArray[0]) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(xArray.count)
        // (0.4 + 0.05) * 2 (data set count) + 0.1 = 1
        data.groupBars(fromX: Double(xArray[0]), groupSpace: groupSpace, barSpace: barSpace)

        barChartView.data = data

        barChartView.gridBackgroundColor = NSUIColor.white

        barChartView.chartDescription.text = "Barchart Demo"
    }

    override open func viewWillAppear() {
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}
