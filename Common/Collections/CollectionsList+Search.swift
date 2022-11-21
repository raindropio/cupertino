import SwiftUI
import API

extension CollectionsList {
    struct Search: ViewModifier {
        var enabled: Bool
        @Binding var search: String
        
        func body(content: Content) -> some View {
            if enabled {
                content
                    .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Find collection")
                    #if canImport(UIKit)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.webSearch)
                    #endif
            } else {
                content
            }
        }
    }
}
