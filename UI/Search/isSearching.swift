import SwiftUI

public extension View {
    func isSearching(_ isSearching: Binding<Bool>) -> some View {
        modifier(IsSearchingModifier(isSearching: isSearching))
    }
}

struct IsSearchingModifier: ViewModifier {
    @Environment(\.isSearching) private var internalIsSearching
    @Binding var isSearching: Bool

    func body(content: Content) -> some View {
        content
            .task(id: internalIsSearching) {
                isSearching = internalIsSearching
            }
    }
}
