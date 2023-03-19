import SwiftUI

@propertyWrapper
public struct IsEditing: DynamicProperty {
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif

    public init() {}
    
    public var wrappedValue: Bool {
        get {
            #if canImport(UIKit)
            editMode?.wrappedValue == .active
            #else
            false
            #endif
        }
        nonmutating set {
            #if canImport(UIKit)
            editMode?.wrappedValue = newValue ? .active : .inactive
            #endif
        }
    }
    
    public func update() {
    }
}
