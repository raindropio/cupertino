import SwiftUI

public extension Backport where Wrapped: View {
    /// Just ignored on iOS <=15
    @ViewBuilder
    func contextMenu<I, M>(forSelectionType itemType: I.Type = I.self, @ViewBuilder menu: @escaping (Set<I>) -> M, primaryAction: ((Set<I>) -> Void)? = nil) -> some View where I : Hashable, M : View {
        if #available(iOS 16, *) {
            content.contextMenu(forSelectionType: itemType, menu: menu, primaryAction: primaryAction)
        } else {
            content
        }
    }
}
