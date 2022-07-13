import SwiftUI
import API
import Combine

struct SearchModifier: ViewModifier {
    var collection: Collection
    @Binding var search: SearchQuery
        
    func body(content: Content) -> some View {
        content
            .searchable(text: $search.text, tokens: $search.tokens) { token in
                Label(token.title, systemImage: token.systemImage)
            }
    }
}
