import SwiftUI
import API
import Common

extension Spotlight {
    struct SearchBar: ViewModifier {
        @State private var focused = true
        @Binding var find: FindBy
        
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
