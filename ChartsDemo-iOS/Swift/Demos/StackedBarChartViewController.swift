//
//  StackedBarChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts

class StackedBarChartViewController: DemoBaseViewController {
    @IBOutlet var chartView: BarChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!

    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"

        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Stacked Bar Chart"
        options = [.toggleValues,
                   .toggleIcons,
                   .toggleHighlight,
                   .animateX,
                   .animateY,
                   .animateXY,
                   .saveToGallery,
                   .togglePinchZoom,
                   .toggleAutoScaleMinMax,
                   .toggleData,
                   .toggleBarBorders]

        chartView.delegate = self

        chartView.chartDescription.isEnabled = false

        chartView.maxVisibleCount = 40
        chartView.isDrawBarShadowEnabled = false
        chartView.isDrawValueAboveBarEnabled = false
        chartView.isHighlightFullBarEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0

        chartView.rightAxis.isEnabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .top

        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 4
        l.xEntrySpace = 6
//        chartView.legend = l

        sliderX.value = 12
        sliderY.value = 100
        slidersValueChanged(nil)

        updateChartData()
    }

    override func updateChartData() {
        if shouldHideData {
            chartView.data = nil
            return
        }

        setChartData(count: Int(sliderX.value + 1), range: UInt32(sliderY.value))
    }

    func setChartData(count: Int, range: UInt32) {
        let yVals = (0 ..< count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val1 = Double(arc4random_uniform(mult) + mult / 3)
            let val2 = Double(arc4random_uniform(mult) + mult / 3)
            let val3 = Double(arc4random_uniform(mult) + mult / 3)

            return BarChartDataEntry(x: Double(i), yValues: [val1, val2, val3], icon: #imageLiteral(resourceName: "icon"))
        }

        let set = BarChartDataSet(entries: yVals, label: "Statistics Vienna 2014")
        set.isDrawIconsEnabled = false

        set.colors = Array(ChartColorTemplates.material[0 ..< 3])
        set.stackLabels = ["Births", "Divorces", "Marriages"]

        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.white)

        chartView.fitBars = true
        chartView.data = data
    }

    override func optionTapped(_ option: Option) {
        super.handleOption(option, forChartView: chartView)
    }

    @IBAction func slidersValueChanged(_: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"

        updateChartData()
    }
}
