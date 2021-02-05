//
//  LineRadarRenderer.swift
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

//open class LineRadarRenderer: LineScatterCandleRadarRenderer { }

extension DataRenderer {
    /// Draws the provided path in filled mode with the provided drawable.
    public func drawFilledPath(context: CGContext, path: CGPath, fill: Fill, fillAlpha: CGFloat) {
        context.saveGState()
        context.beginPath()
        context.addPath(path)

        // filled is usually drawn with less alpha
        context.setAlpha(fillAlpha)

        fill.fillPath(context: context, rect: viewPortHandler.contentRect)

        context.restoreGState()
    }
}
