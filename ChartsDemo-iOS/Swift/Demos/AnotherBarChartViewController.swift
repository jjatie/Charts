//
//  AnotherBarChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts

class AnotherBarChartViewController: DemoBaseViewController {
    @IBOutlet var chartView: BarChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Another Bar Chart"

        options = [.toggleValues,
                   .toggleHighlight,
                   .animateX,
                   .animateY,
                   .animateXY,
                   .saveToGallery,
                   .togglePinchZoom,
                   .toggleData,
                   .toggleBarBorders]

        chartView.delegate = self

        chartView.chartDescription.isEnabled = false
        chartView.maxVisibleCount = 60
        chartView.isPinchZoomEnabled = false
        chartView.isDrawBarShadowEnabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom

        chartView.legend.isEnabled = false

        sliderX.value = 10
        sliderY.value = 100
        slidersValueChanged(nil)
    }

    override func updateChartData() {
        if shouldHideData {
            chartView.data = nil
            return
        }

        setDataCount(Int(sliderX.value) + 1, range: Double(sliderY.value))
    }

    func setDataCount(_ count: Int, range: Double) {
        let yVals = (0 ..< count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(UInt32(mult))) + mult / 3
            return BarChartDataEntry(x: Double(i), y: val)
        }

        var set1: BarChartDataSet!
        if let set = chartView.data?.first as? BarChartDataSet {
            set1 = set
            set1?.replaceEntries(yVals)
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "Data Set")
            set1.colors = ChartColorTemplates.vordiplom
            set1.isDrawValuesEnabled = false

            let data = BarChartData(dataSet: set1)
            chartView.data = data
            chartView.fitBars = true
        }

        chartView.setNeedsDisplay()
    }

    override func optionTapped(_ option: Option) {
        super.handleOption(option, forChartView: chartView)
    }

    // MARK: - Actions

    @IBAction func slidersValueChanged(_: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"

        updateChartData()
    }
}
