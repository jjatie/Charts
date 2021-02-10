import CoreGraphics
import Foundation

public typealias LineChartDataSet = ChartDataSet<ChartDataEntry>

extension LineChartDataSet {
    /// - Returns: The color at the given index of the DataSet's circle-color array.
    /// Performs a IndexOutOfBounds check by modulus.
    public func getCircleColor(at index: Int) -> NSUIColor? {
        let size = style.circleColors.count
        let index = index % size
        if index >= size {
            return nil
        }
        return style.circleColors[index]
    }

    /// Sets the one and ONLY color that should be used for this DataSet.
    /// Internally, this recreates the colors array and adds the specified color.
    public mutating func setCircleColor(_ color: NSUIColor) {
        style.circleColors.removeAll(keepingCapacity: false)
        style.circleColors.append(color)
    }
}
