import SwiftUI
import API

extension CollectionsList {
    struct Search: ViewModifier {
        var enabled: Bool
        @Binding var search: String
        
        func body(content: Content) -> some View {
            if enabled {
                content
                    .filterable(text: $search, prompt: "Search collection", autoFocus: false)
            } else {
                content
            }
        }
    }
}
