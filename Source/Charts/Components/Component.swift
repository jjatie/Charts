import CoreGraphics

/// This class encapsulates everything both Axis, Legend and LimitLines have in common
public protocol Component {
    /// flag that indicates if this component is enabled or not
    var isEnabled: Bool { get }

    /// The offset this component has on the x-axis
    var xOffset: CGFloat { get }

    /// The offset this component has on the x-axis
    var yOffset: CGFloat { get }
}
