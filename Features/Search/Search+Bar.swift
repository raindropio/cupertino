import SwiftUI
import API

extension Search {
    struct Bar: ViewModifier {
        @Binding var refine: FindBy

        func body(content: Content) -> some View {
            content
                .searchable(
                    text: $refine.text,
                    tokens: $refine.filters,
                    token: FilterRow.init
                )
                #if canImport(UIKit)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.webSearch)
                #endif
        }
    }
}
