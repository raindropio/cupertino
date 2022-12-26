import SwiftUI

public extension View {
    func transformTags(_ converter: @escaping (_ original: AnyHashable) -> AnyHashable) -> some View {
        environment(\.transformTag, converter)
    }
}

private struct TansformTagKey: EnvironmentKey {
    static let defaultValue: (AnyHashable) -> AnyHashable = { $0 }
}

public extension EnvironmentValues {
    var transformTag: (AnyHashable) -> AnyHashable {
        get { self[TansformTagKey.self] }
        set {
            self[TansformTagKey.self] = newValue
        }
    }
}
