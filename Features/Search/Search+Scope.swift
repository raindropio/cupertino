import SwiftUI
import API
import UI

extension Search {
    struct Scope: ViewModifier {
        var base: FindBy
        @Binding var refine: FindBy
        
        func body(content: Content) -> some View {
            content
                .searchScopes($refine.collectionId, activation: .onSearchPresentation) {
                    if base.collectionId != 0 {
                        Text("Everywhere")
                            .tag(0)
                        
                        CollectionLabel(base.collectionId)
                            .labelStyle(.titleOnly)
                            .tag(base.collectionId)
                    }
                }
        }
    }
}
