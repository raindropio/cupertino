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
                .textInputAutocapitalization(.never)
                .keyboardType(.webSearch)
                .submitLabel(.search)
                #endif
                .searchCompletionButtons(
                    text: $refine.text,
                    tokens: $refine.filters
                )
        }
    }
}
