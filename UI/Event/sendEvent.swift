import SwiftUI

fileprivate struct SendEventKey: EnvironmentKey {
    static let defaultValue: (String, Any) -> Void = { _, _ in }
}

public extension EnvironmentValues {
    var sendEvent: (String, Any) -> Void {
        get { self[SendEventKey.self] }
        set { self[SendEventKey.self] = newValue }
    }
}

