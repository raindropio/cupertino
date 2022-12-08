import SwiftUI

public extension View {
    func searchFocused(_ condition: Binding<Bool>) -> some View {
        modifier(SearchFocusedModifier(condition: condition))
    }
}

fileprivate struct SearchFocusedModifier: ViewModifier {
    @State private var searchController: UISearchController?
    @Binding var condition: Bool
    
    @MainActor
    func setFocus() {
        guard let searchController else { return }
        guard searchController.searchBar.isFirstResponder != condition else { return }

        if condition {
            searchController.searchBar.searchTextField.becomeFirstResponder()
        } else {
            searchController.searchBar.searchTextField.resignFirstResponder()
        }
    }
    
    func body(content: Content) -> some View {
        content
            .withSearchController($searchController)
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) {
                if $0.object is UISearchTextField {
                    condition = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) {
                if $0.object is UISearchTextField {
                    condition = false
                }
            }
            .task(id: condition) { setFocus() }
            .task(id: searchController) { setFocus() }
    }
}
