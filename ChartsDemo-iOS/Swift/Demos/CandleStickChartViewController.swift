//
//  CandleStickChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts

class CandleStickChartViewController: DemoBaseViewController {
    @IBOutlet var chartView: CandleStickChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Candle Stick Chart"
        options = [.toggleValues,
                   .toggleIcons,
                   .toggleHighlight,
                   .animateX,
                   .animateY,
                   .animateXY,
                   .saveToGallery,
                   .togglePinchZoom,
                   .toggleAutoScaleMinMax,
                   .toggleShadowColorSameAsCandle,
                   .toggleShowCandleBar,
                   .toggleData]

        chartView.delegate = self

        chartView.chartDescription.isEnabled = false

        chartView.isDragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 200
        chartView.isPinchZoomEnabled = true

        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .vertical
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!

        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0

        chartView.rightAxis.isEnabled = false

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!

        sliderX.value = 10
        sliderY.value = 50
        slidersValueChanged(nil)
    }

    override func updateChartData() {
        if shouldHideData {
            chartView.data = nil
            return
        }

        setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0 ..< count).map { (i) -> CandleChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(40) + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0

            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "icon")!)
        }

        let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80 / 255, alpha: 1))
        set1.isDrawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.isDecreasingFilled = true
        set1.increasingColor = UIColor(red: 122 / 255, green: 242 / 255, blue: 84 / 255, alpha: 1)
        set1.isIncreasingFilled = false
        set1.neutralColor = .blue

        let data = CandleChartData(dataSet: set1)
        chartView.data = data
    }

    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleShadowColorSameAsCandle:
            for case let set as CandleChartDataSet in chartView.data! {
                set.isShadowColorSameAsCandle.toggle()
            }
            chartView.notifyDataSetChanged()
        case .toggleShowCandleBar:
            for case let set as CandleChartDataSet in chartView.data! {
                set.showCandleBar.toggle()
            }
            chartView.notifyDataSetChanged()
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
