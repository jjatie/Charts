//
//  CubicLineChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts

private class CubicLineSampleFillFormatter: FillFormatter {
    func getFillLinePosition(dataSet _: LineChartDataSet, dataProvider _: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

class CubicLineChartViewController: DemoBaseViewController {
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Cubic Line Chart"

        options = [.toggleValues,
                   .toggleFilled,
                   .toggleCircles,
                   .toggleCubic,
                   .toggleHorizontalCubic,
                   .toggleStepped,
                   .toggleHighlight,
                   .animateX,
                   .animateY,
                   .animateXY,
                   .saveToGallery,
                   .togglePinchZoom,
                   .toggleAutoScaleMinMax,
                   .toggleData]

        chartView.delegate = self

        chartView.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
        chartView.backgroundColor = UIColor(red: 104 / 255, green: 241 / 255, blue: 175 / 255, alpha: 1)

        chartView.isDragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.isPinchZoomEnabled = false
        chartView.maxHighlightDistance = 300

        chartView.xAxis.isEnabled = false

        let yAxis = chartView.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .insideChart
        yAxis.axisLineColor = .white

        chartView.rightAxis.isEnabled = false
        chartView.legend.isEnabled = false

        sliderX.value = 45
        sliderY.value = 100
        slidersValueChanged(nil)

        chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
    }

    override func updateChartData() {
        if shouldHideData {
            chartView.data = nil
            return
        }

        setDataCount(Int(sliderX.value + 1), range: UInt32(sliderY.value))
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0 ..< count).map { (i) -> ChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult) + 20)
            return ChartDataEntry(x: Double(i), y: val)
        }

        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
        set1.mode = .cubicBezier
        set1.isDrawCirclesEnabled = false
        set1.lineWidth = 1.8
        set1.circleRadius = 4
        set1.setCircleColor(.white)
        set1.highlightColor = UIColor(red: 244 / 255, green: 117 / 255, blue: 117 / 255, alpha: 1)
        set1.fill = ColorFill(color: .white)
        set1.fillAlpha = 1
        set1.isHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()

        let data = LineChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9)!)
        data.setDrawValues(false)

        chartView.data = data
    }

    override func optionTapped(_ option: Option) {
        guard let data = chartView.data else { return }

        switch option {
        case .toggleFilled:
            for case let set as LineChartDataSet in data {
                set.isDrawFilledEnabled.toggle()
            }
            chartView.setNeedsDisplay()

        case .toggleCircles:
            for case let set as LineChartDataSet in data {
                set.isDrawCirclesEnabled.toggle()
            }
            chartView.setNeedsDisplay()

        case .toggleCubic:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
            }
            chartView.setNeedsDisplay()

        case .toggleStepped:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .stepped) ? .linear : .stepped
            }
            chartView.setNeedsDisplay()

        case .toggleHorizontalCubic:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
            }
            chartView.setNeedsDisplay()

        default:
            super.handleOption(option, forChartView: chartView)
        }
    }

    // MARK: - Actions

    @IBAction func slidersValueChanged(_: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"

        updateChartData()
    }
}
