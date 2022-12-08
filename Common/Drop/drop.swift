import SwiftUI

struct DropEnvironmentKey: EnvironmentKey {
    static let defaultValue: ((_ items: [NSItemProvider], _ collection: Int) -> Void)? = nil
}

public extension EnvironmentValues {
    var drop: (([NSItemProvider], Int) -> Void)? {
        get {
            self[DropEnvironmentKey.self]
        } set {
            self[DropEnvironmentKey.self] = newValue
        }
    }
}
