//
//  CombinedChartTests.swift
//  ChartsTests
//
//  Created by Xuan Liu on 14/10/2017.
//

@testable import Charts
import SnapshotTesting
import XCTest

class CombinedChartTests: XCTestCase {
    lazy var icon = UIImage(named: "icon", in: .module, compatibleWith: nil)!

    var chart: CombinedChartView!
    var lineDataSet: LineChartDataSet!
    var barDataSet: BarChartDataSet!

    override func setUp() {
        super.setUp()

        // Set to `true` to re-capture all snapshots
        isRecording = false

        // Sample data
        let combinedData = CombinedChartData()
        combinedData.barData = generateBarData()
        combinedData.lineData = generateLineData()
        chart = CombinedChartView(frame: CGRect(x: 0, y: 0, width: 480, height: 350))
        chart.backgroundColor = NSUIColor.clear
        chart.leftAxis.axisMinimum = 0.0
        chart.rightAxis.axisMinimum = 0.0
        chart.data = combinedData
    }

    func generateBarData() -> BarChartData {
        let values: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
                                76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
                                99, 14, 84, 48, 40, 71, 106, 41, 45, 61]

        let entries = values.enumerated().map { (i, value) in
            BarChartDataEntry(x: Double(i), y: value, icon: icon)
        }

        barDataSet = BarChartDataSet(entries: entries, label: "Bar chart unit test data")
        barDataSet.isDrawIconsEnabled = false

        let data = BarChartData(dataSet: barDataSet)
        data.barWidth = 0.85
        return data
    }

    func generateLineData() -> LineChartData {
        let values: [Double] = [0, 254, 81, 93, 52, 44, 97, 101, 75, 28,
                                76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
                                99, 14, 84, 48, 40, 71, 106, 41, 45, 61]

        let entries = values.enumerated().map { (i, value) in
            ChartDataEntry(x: Double(i), y: value, icon: icon)
        }
        lineDataSet = LineChartDataSet(entries: entries, label: "Line chart unit test data")
        lineDataSet.isDrawIconsEnabled = false
        return LineChartData(dataSet: lineDataSet)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDefaultAxisDependency() {
        assertChartSnapshot(matching: chart)
    }

    func testLeftRightAxisDependency() {
        lineDataSet.axisDependency = .left
        barDataSet.axisDependency = .right
        (chart.data as? CombinedChartData)?.notifyDataChanged()
        chart.notifyDataSetChanged()
        assertChartSnapshot(matching: chart)
    }

    func testAllRightAxisDependency() {
        lineDataSet.axisDependency = .right
        barDataSet.axisDependency = .right
        (chart.data as? CombinedChartData)?.notifyDataChanged()
        chart.notifyDataSetChanged()
        assertChartSnapshot(matching: chart)
    }
}
