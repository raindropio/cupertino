import Foundation

@propertyWrapper
public struct Persisted<Value: Codable & Equatable>: Equatable {
    typealias Restore = ((Value) -> Value)?

    private var _value: Value
    private var storage: Storage
    
    init(wrappedValue: Value, _ cacheKey: String, _ restore: Restore = nil) {
        self.storage = .init(cacheKey)
        self._value = storage.load(transform: restore) ?? wrappedValue
    }
    
    public var wrappedValue: Value {
        get {
            _value
        }
        
        set {
            _value = newValue
            storage.save(newValue)
        }
    }
}
