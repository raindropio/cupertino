import SwiftUI

public extension View {
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    func itemAction<I>(forSelectionType type: I.Type = I.self, action: @escaping (Set<I>) -> Void) -> some View where I : Hashable {
        contextAction(forSelectionType: type, action: action)
            .environment(\.itemAction) { items in
                action(Set(items.compactMap { $0 as? I }))
            }
    }
}

struct ItemActionKey: EnvironmentKey {
    static let defaultValue: ((Set<AnyHashable>) -> Void)? = nil
}

public extension EnvironmentValues {
    var itemAction: ((Set<AnyHashable>) -> Void)? {
        get { self[ItemActionKey.self] }
        set { self[ItemActionKey.self] = newValue }
    }
}
