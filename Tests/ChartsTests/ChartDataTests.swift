//
//  ChartDataTests.swift
//  ChartsTests
//
//  Created by Peter Kaminski on 1/23/20.
//

@testable import Charts
import XCTest

class ChartDataTests: XCTestCase {
    var data: ScatterChartData!

    private enum SetLabels {
        static let one = "label1"
        static let two = "label2"
        static let three = "label3"
        static let badLabel = "Bad label"
    }

    override func setUp() {
        super.setUp()

        let setCount = 5
        let range: UInt32 = 32
        let values1 = (0 ..< setCount).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let values2 = (0 ..< setCount).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let values3 = (0 ..< setCount).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }

        let set1 = ScatterChartDataSet(entries: values1, label: SetLabels.one)
        let set2 = ScatterChartDataSet(entries: values2, label: SetLabels.two)
        let set3 = ScatterChartDataSet(entries: values3, label: SetLabels.three)

        data = ScatterChartData(dataSets: [set1, set2, set3])
    }

    func testGetDataSetByLabelCaseSensitive() {
        XCTAssertEqual(data.index(ofLabel: SetLabels.one, ignoreCase: false), 0)
        XCTAssertEqual(data.index(ofLabel: SetLabels.two, ignoreCase: false), 1)
        XCTAssertEqual(data.index(ofLabel: SetLabels.three, ignoreCase: false), 2)
        XCTAssertNil(data.index(ofLabel: SetLabels.one.uppercased(), ignoreCase: false))
    }

    func testGetDataSetByLabelIgnoreCase() {
        XCTAssertEqual(data.index(ofLabel: SetLabels.one, ignoreCase: true), 0)
        XCTAssertEqual(data.index(ofLabel: SetLabels.two, ignoreCase: true), 1)
        XCTAssertEqual(data.index(ofLabel: SetLabels.three, ignoreCase: true), 2)

        XCTAssertEqual(data.index(ofLabel: SetLabels.one.uppercased(), ignoreCase: true), 0)
        XCTAssertEqual(data.index(ofLabel: SetLabels.two.uppercased(), ignoreCase: true), 1)
        XCTAssertEqual(data.index(ofLabel: SetLabels.three.uppercased(), ignoreCase: true), 2)
    }

    func testGetDataSetByLabelNilWithBadLabel() {
        XCTAssertNil(data.index(ofLabel: SetLabels.badLabel, ignoreCase: true))
        XCTAssertNil(data.index(ofLabel: SetLabels.badLabel, ignoreCase: false))
    }
}
