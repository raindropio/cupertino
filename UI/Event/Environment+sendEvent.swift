import SwiftUI

fileprivate struct SendEventKey: EnvironmentKey {
    static let defaultValue: (Notification.Name, Any) -> Void = { name, object in
        NotificationCenter.default
            .post(name: name, object: object)
    }
}

public extension EnvironmentValues {
    var sendEvent: (Notification.Name, Any) -> Void {
        self[SendEventKey.self]
    }
}
