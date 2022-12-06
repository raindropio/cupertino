import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func searchScopes<V: Hashable, S: View>(_ scope: Binding<V>, @ViewBuilder scopes: @escaping () -> S) -> some View {
        if #available(iOS 16, *) {
            content.searchScopes(scope, scopes: scopes)
        } else {
            content.modifier(SearchScopes(scope: scope, scopes: scopes))
        }
    }
}

fileprivate struct SearchScopes<V: Hashable, S: View>: ViewModifier {
    @State private var searchFocused = false
    @Binding var scope: V
    var scopes: () -> S

    private var isEmpty: Bool {
        let view = scopes()
        return "\(view)" == "nil"
    }

    private var showScope: Bool {
        searchFocused && !isEmpty
    }

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if showScope {
                Picker("", selection: $scope, content: scopes)
                    .pickerStyle(.segmented)
                    .scenePadding(.horizontal)
                    .scenePadding(.bottom)
                    .background(.bar)
                    .overlay(alignment: .bottom) {
                        Divider().opacity(0.7)
                    }
                    .transition(.opacity)
            }

            content
                .animation(nil, value: showScope)
        }
            .animation(.default.delay(0.2), value: showScope)
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) {
                if $0.object is UISearchTextField {
                    searchFocused = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) {
                if $0.object is UISearchTextField {
                    searchFocused = false
                }
            }
    }
}
