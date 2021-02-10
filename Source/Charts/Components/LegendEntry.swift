//
//  LegendEntry.swift
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

public struct LegendEntry {
    /// - Parameters:
    /// - label: The legend entry text.
    /// A `nil` label will start a group.
    public init(label: String?) {
        self.label = label
    }

    /// The legend entry text.
    /// A `nil` label will start a group.
    public var label: String?

    /// The color for drawing the label
    public var labelColor: NSUIColor?

    /// The form to draw for this entry.
    ///
    /// `None` will avoid drawing a form, and any related space.
    /// `Empty` will avoid drawing a form, but keep its space.
    /// `Default` will use the Legend's default.
    public var form: Legend.Form = .default

    /// Form size will be considered except for when .None is used
    ///
    /// Set as NaN to use the legend's default
    public var formSize = CGFloat.nan

    /// Line width used for shapes that consist of lines.
    ///
    /// Set to NaN to use the legend's default.
    public var formLineWidth = CGFloat.nan

    /// Line dash configuration for shapes that consist of lines.
    ///
    /// This is how much (in pixels) into the dash pattern are we starting from.
    ///
    /// Set to NaN to use the legend's default.
    public var formLineDashPhase: CGFloat = 0.0

    /// Line dash configuration for shapes that consist of lines.
    ///
    /// This is the actual dash pattern.
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    ///
    /// Set to nil to use the legend's default.
    public var formLineDashLengths: [CGFloat]?

    /// The color for drawing the form
    public var formColor: NSUIColor?
}
