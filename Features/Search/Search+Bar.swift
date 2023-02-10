import SwiftUI
import API
import UI

extension Search {
    struct Bar: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass
        @Binding var refine: FindBy
        
        private var placement: SearchFieldPlacement {
            if sizeClass == .regular {
                return .automatic
            } else {
                return .navigationBarDrawer(displayMode: refine.isSearching ? .always : .automatic)
            }
        }

        func body(content: Content) -> some View {
            content
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
