import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func tag<V: Hashable>(_ tag: V) -> some View {
        if #available(iOS 16, *) {
            content.tag(tag)
        } else {
            content
                .environment(\.backportTag, tag)
                .tag(tag)
        }
    }
}

struct BackportTagKey: EnvironmentKey {
    static let defaultValue: AnyHashable? = nil
}

extension EnvironmentValues {
    var backportTag: AnyHashable? {
        get {
            self[BackportTagKey.self]
        }
        set {
            if self[BackportTagKey.self] != newValue {
                self[BackportTagKey.self] = newValue
            }
        }
    }
}
