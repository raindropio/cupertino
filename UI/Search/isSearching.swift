import SwiftUI

struct IsSearchingModifier: ViewModifier {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    @Binding var val: Bool
    
    func body(content: Content) -> some View {
        content
            .task(id: isSearching) {
                if val != isSearching {
                    val = isSearching
                }
            }
            .onChange(of: val) {
                if !$0 {
                    dismissSearch()
                }
            }
    }
}

public extension View {
    func isSearching(_ val: Binding<Bool>) -> some View {
        modifier(IsSearchingModifier(val: val))
    }
}
