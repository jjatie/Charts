import CoreGraphics

extension NSUIColor {
    static var defaultDataSet: Self {
        Self(red: 140.0 / 255.0, green: 234.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
}

public protocol ChartStyleKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

public struct ChartStyle<EntryType: ChartDataEntry2D> {
    public init() { }

    private var __storage: [ObjectIdentifier : Any] = [:]

    public subscript<K: ChartStyleKey>(key: K.Type) -> K.Value {
        get { __storage[ObjectIdentifier(key)] as? K.Value ?? key.defaultValue }
        set { __storage[ObjectIdentifier(key)] = newValue }
    }
}

