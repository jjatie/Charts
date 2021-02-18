//
//  BubbleDataEntry.swift
//  Charts
//
//  Bubble chart implementation:
//    Copyright 2015 Pierre-Marc Airoldi
//    Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import CoreGraphics
import Foundation

public struct BubbleChartDataEntry: ChartDataEntry2D {
    public var x: Double = 0.0
    public var y: Double = 0.0

    /// optional icon image
    public var icon: NSUIImage?

    /// The size of the bubble.
    public var size: CGFloat = 0.0

    public init() { }

    /// - Parameters:
    ///   - x: The index on the x-axis.
    ///   - y: The value on the y-axis.
    ///   - size: The size of the bubble.
    ///   - icon: icon image
    public init(x: Double, y: Double, size: CGFloat, icon: NSUIImage? = nil) {
        self.x = x
        self.y = y
        self.icon = icon
        self.size = size
    }
}

extension BubbleChartDataEntry: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs.size == rhs.size
    }
}
