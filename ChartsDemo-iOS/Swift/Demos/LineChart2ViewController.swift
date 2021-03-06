//
//  LineChart2ViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts

class LineChart2ViewController: DemoBaseViewController {
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Line Chart 2"
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

        chartView.chartDescription.isEnabled = false
        chartView.isDragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.isPinchZoomEnabled = true

        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false

        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51 / 255, green: 181 / 255, blue: 229 / 255, alpha: 1)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true

        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 900
        rightAxis.axisMinimum = -200
        rightAxis.granularityEnabled = false

        sliderX.value = 20
        sliderY.value = 30
        slidersValueChanged(nil)

        chartView.animate(xAxisDuration: 2.5)
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
            let mult = range / 2
            let val = Double(arc4random_uniform(mult) + 50)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals2 = (0 ..< count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 450)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals3 = (0 ..< count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 500)
            return ChartDataEntry(x: Double(i), y: val)
        }

        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51 / 255, green: 181 / 255, blue: 229 / 255, alpha: 1))
        set1.setCircleColor(.white)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65 / 255
        set1.fill = ColorFill(color: UIColor(red: 51 / 255, green: 181 / 255, blue: 229 / 255, alpha: 1))
        set1.highlightColor = UIColor(red: 244 / 255, green: 117 / 255, blue: 117 / 255, alpha: 1)
        set1.isDrawCircleHoleEnabled = false

        let set2 = LineChartDataSet(entries: yVals2, label: "DataSet 2")
        set2.axisDependency = .right
        set2.setColor(.red)
        set2.setCircleColor(.white)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65 / 255
        set2.fill = ColorFill(color: .red)
        set2.highlightColor = UIColor(red: 244 / 255, green: 117 / 255, blue: 117 / 255, alpha: 1)
        set2.isDrawCircleHoleEnabled = false

        let set3 = LineChartDataSet(entries: yVals3, label: "DataSet 3")
        set3.axisDependency = .right
        set3.setColor(.yellow)
        set3.setCircleColor(.white)
        set3.lineWidth = 2
        set3.circleRadius = 3
        set3.fillAlpha = 65 / 255
        set3.fill = ColorFill(color: UIColor.yellow.withAlphaComponent(200 / 255))
        set3.highlightColor = UIColor(red: 244 / 255, green: 117 / 255, blue: 117 / 255, alpha: 1)
        set3.isDrawCircleHoleEnabled = false

        let data: LineChartData = [set1, set2, set3]
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9))

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

    @IBAction func slidersValueChanged(_: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"

        updateChartData()
    }

    // }
    // TODO: Declarations in extensions cannot override yet.
    // extension LineChart2ViewController {
    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        super.chartValueSelected(chartView, entry: entry, highlight: highlight)

        self.chartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
                                            axis: self.chartView.data![highlight.dataSetIndex].axisDependency,
                                            duration: 1)
        // [_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
        // [_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    }
}
