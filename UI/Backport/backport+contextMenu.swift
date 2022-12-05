import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder
    func contextMenu<I, M>(forSelectionType itemType: I.Type = I.self, @ViewBuilder menu: @escaping (Set<I>) -> M, primaryAction: ((Set<I>) -> Void)? = nil) -> some View where I : Hashable, M : View {
        if #available(iOS 16, *) {
            content.contextMenu(forSelectionType: itemType, menu: menu, primaryAction: primaryAction)
        } else {
            content.modifier(ListContextMenuModifier(primaryAction: primaryAction))
        }
    }
}

fileprivate struct ListContextMenuModifier<I: Hashable>: ViewModifier {
    var primaryAction: ((Set<I>) -> Void)? = nil
    
    func action(_ item: AnyHashable) {
        if let i = item as? I {
            primaryAction?(.init([i]))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.backportListPrimaryAction, primaryAction != nil ? action : nil)
    }
}

fileprivate struct ListPrimaryActionKey: EnvironmentKey {
    static let defaultValue: ((AnyHashable) -> Void)? = nil
}

extension EnvironmentValues {
    var backportListPrimaryAction: ((AnyHashable) -> Void)? {
        get {
            self[ListPrimaryActionKey.self]
        }
        set {
            self[ListPrimaryActionKey.self] = newValue
        }
    }
}
