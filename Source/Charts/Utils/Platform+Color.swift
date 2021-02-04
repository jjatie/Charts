//
//  Platform+Color.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#if canImport(UIKit)
import UIKit

public typealias NSUIColor = UIColor

extension UIColor {
    static var labelOrBlack: UIColor {
        if #available(iOS 13, tvOS 13, *) {
            return .label
        } else {
            return .black
        }
    }
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public typealias NSUIColor = NSColor

extension NSColor {
    static var labelOrBlack: NSColor {
        if #available(macOS 10.14, *) {
            return .labelColor
        } else {
            return .black
        }
    }
}
#endif
