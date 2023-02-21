import SwiftUI
import API
import UI
import Backport

extension Search {
    struct Bar: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass
        @Binding var refine: FindBy
        
        private var placement: SearchFieldPlacement {
            .toolbar
        }

        func body(content: Content) -> some View {
            content
                .backport.fixSearchAppearance()
                .searchable(
                    text: $refine.text,
                    tokens: $refine.filters,
                    placement: placement,
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
