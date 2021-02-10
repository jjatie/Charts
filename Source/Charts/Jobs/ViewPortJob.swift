//
//  ViewPortJob.swift
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

// This defines a viewport modification job, used for delaying or animating viewport changes
open class ViewPortJob {
    unowned var viewPortHandler: ViewPortHandler
    var xValue = 0.0
    var yValue = 0.0
    unowned var transformer: Transformer
    unowned var view: NSUIView

    public init(
        viewPortHandler: ViewPortHandler,
        xValue: Double,
        yValue: Double,
        transformer: Transformer,
        view: NSUIView
    ) {
        self.viewPortHandler = viewPortHandler
        self.xValue = xValue
        self.yValue = yValue
        self.transformer = transformer
        self.view = view
    }

    open func doJob() {
        fatalError("`doJob()` must be overridden by subclasses")
    }
}
