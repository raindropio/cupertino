import SwiftUI
import API

public struct SearchBar: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @Binding var find: FindBy
    @State private var text: String
    
    public init(find: Binding<FindBy>) {
        self._find = find
        self.text = find.wrappedValue.text
    }
    
    public func body(content: Content) -> some View {
        content
            .searchable(text: $text) {
                if !text.isEmpty {
                    FoundCollections(text: text)
                } else {
                    RecentSearches(find: find)
                }
            }
            .task(id: text, priority: .background, debounce: 0.3) {
                find.text = text
            }
            .task { try? await dispatch(RecentAction.reload(find)) }
            #if canImport(UIKit)
            .textInputAutocapitalization(.never)
            .keyboardType(.webSearch)
            .submitLabel(.search)
            #endif
    }
}
