import Foundation

@propertyWrapper
public struct Cached<Value: Codable>: Equatable where Value: Equatable {
    typealias Transform = ((Value) -> Value)?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._value == rhs._value
    }
    
    private var _value: Value
    private var cacheKey: String
    private var transform: Transform = nil
    
    init(wrappedValue: Value, _ cacheKey: String, _ transform: Transform = nil) {
        self._value = /*CachedFileStorage.load(cacheKey) ??*/ wrappedValue
        self.cacheKey = cacheKey
        self.transform = transform
    }
    
    public var wrappedValue: Value {
        get {
            _value
        }
        
        set {
            if _value != newValue {
                _value = newValue
                
//                CachedFileStorage.save(
//                    cacheKey,
//                    value: transform?(newValue) ?? newValue,
//                    debounce: 0.5
//                )
            }
        }
    }
}
