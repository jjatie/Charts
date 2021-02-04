//
//  Platform+Gestures.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

// MARK: - UIKit

#if canImport(UIKit)
    import UIKit

    public typealias NSUIGestureRecognizer = UIGestureRecognizer
    public typealias NSUIGestureRecognizerState = UIGestureRecognizer.State
    public typealias NSUIGestureRecognizerDelegate = UIGestureRecognizerDelegate
    public typealias NSUITapGestureRecognizer = UITapGestureRecognizer
    public typealias NSUIPanGestureRecognizer = UIPanGestureRecognizer

    extension NSUIGestureRecognizer {
        final var nsuiNumberOfTouches: Int {
            numberOfTouches
        }

        final func nsuiLocationOfTouch(_ touch: Int, inView: UIView?) -> CGPoint {
            location(ofTouch: touch, in: inView)
        }
    }

    extension NSUITapGestureRecognizer {
        final var nsuiNumberOfTapsRequired: Int {
            get { numberOfTapsRequired }
            set { numberOfTapsRequired = newValue }
        }
    }

    #if !os(tvOS)
        public typealias NSUIPinchGestureRecognizer = UIPinchGestureRecognizer
        public typealias NSUIRotationGestureRecognizer = UIRotationGestureRecognizer

        extension NSUIRotationGestureRecognizer {
            final var nsuiRotation: CGFloat {
                get { rotation }
                set { rotation = newValue }
            }
        }

        extension NSUIPinchGestureRecognizer {
            final var nsuiScale: CGFloat {
                get { scale }
                set { scale = newValue }
            }
        }
    #endif
#endif

// MARK: - AppKit

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    import AppKit

    public typealias NSUIGestureRecognizer = NSGestureRecognizer
    public typealias NSUIGestureRecognizerState = NSGestureRecognizer.State
    public typealias NSUIGestureRecognizerDelegate = NSGestureRecognizerDelegate
    public typealias NSUITapGestureRecognizer = NSClickGestureRecognizer
    public typealias NSUIPanGestureRecognizer = NSPanGestureRecognizer
    public typealias NSUIPinchGestureRecognizer = NSMagnificationGestureRecognizer
    public typealias NSUIRotationGestureRecognizer = NSRotationGestureRecognizer

    extension NSUIGestureRecognizer {
        final var nsuiNumberOfTouches: Int {
            1
        }

        // FIXME: Currently there are no more than 1 touch in OSX gestures, and not way to create custom touch gestures.
        final func nsuiLocationOfTouch(_: Int, inView: NSView?) -> CGPoint {
            location(in: inView)
        }
    }

    /** The 'tap' gesture is mapped to clicks. */
    extension NSUITapGestureRecognizer {
        final var nsuiNumberOfTapsRequired: Int {
            get { numberOfClicksRequired }
            set { numberOfClicksRequired = newValue }
        }
    }

    extension NSUIRotationGestureRecognizer {
        // FIXME: Currently there are no velocities in OSX gestures, and not way to create custom touch gestures.
        final var velocity: CGFloat {
            0.1
        }

        final var nsuiRotation: CGFloat {
            get { -rotation }
            set { rotation = -newValue }
        }
    }

    extension NSUIPinchGestureRecognizer {
        final var nsuiScale: CGFloat {
            get { magnification + 1.0 }
            set { magnification = newValue - 1.0 }
        }
    }
#endif
