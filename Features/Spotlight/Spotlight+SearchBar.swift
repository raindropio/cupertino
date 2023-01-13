import SwiftUI
import API

extension Spotlight {
    struct SearchBar: ViewModifier {
        @Binding var find: FindBy
        @Binding var focused: Bool

        func body(content: Content) -> some View {
            content
                .backport.searchable(
                    text: $find.text,
                    tokens: $find.filters,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Quick search"),
                    token: FilterRow.init
                )
                #if canImport(UIKit)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.webSearch)
                #endif
                .searchFocused($focused)
        }
    }
}
