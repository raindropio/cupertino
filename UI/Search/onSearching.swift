import SwiftUI

public extension View {
    func onSearching(perform: @escaping (Bool) -> Void) -> some View {
        modifier(OnSearching(perform: perform))
    }
}

fileprivate struct OnSearching: ViewModifier {
    @Environment(\.isSearching) private var isSearching
    var perform: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear { perform(isSearching) }
            .onChange(of: isSearching, perform: perform)
            //react to cancel faster
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) {
                if $0.object is UISearchTextField {
                    perform(false)
                }
            }
    }
}
