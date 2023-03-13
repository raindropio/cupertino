import SwiftUI
import API
import UI
import Backport

extension Search {
    struct Bar: ViewModifier {
        @Binding var refine: FindBy
        
        func body(content: Content) -> some View {
            content
                .backport.fixSearchAppearance()
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
                .searchCompletionButtons(
                    text: $refine.text,
                    tokens: $refine.filters
                )
        }
    }
}
