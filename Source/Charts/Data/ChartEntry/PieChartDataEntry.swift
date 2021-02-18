//
//  PieChartDataEntry.swift
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

public struct PieChartDataEntry: ChartDataEntry2D {
    public let x: Double = .nan
    
    public var y: Double = 0
    
    public var value: Double {
        get { y }
        set { y = newValue }
    }

    public var label: String?

    /// optional icon image
    public var icon: NSUIImage?

    public init() { }

    /// - Parameters:
    ///   - value: The value on the y-axis
    public init(value: Double, label: String? = nil, icon: NSUIImage? = nil) {
        self.y = value
        self.label = label
        self.icon = icon
    }
}

// MARK: - Equatable

extension PieChartDataEntry: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.y == rhs.y &&
            lhs.label == rhs.label &&
            lhs.icon == rhs.icon
    }
}

// MARK: - CustomStringConvertible

extension PieChartDataEntry: CustomStringConvertible { }
