import SwiftUI

public extension View {
    func searchFocused(_ condition: Binding<Bool>) -> some View {
        modifier(SearchFocusedModifier(condition: condition))
    }
}

fileprivate struct SearchFocusedModifier: ViewModifier {
    @State private var searchController: UISearchController?
    @Binding var condition: Bool
    
    @Sendable
    func setFocus() async {
        guard let searchController else { return }
        guard await searchController.searchBar.isFirstResponder != condition else { return }
        if condition {
            await searchController.searchBar.becomeFirstResponder()
        } else {
            await searchController.searchBar.resignFirstResponder()
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
            .task(id: condition, setFocus)
            .task(id: searchController, setFocus)
    }
}
