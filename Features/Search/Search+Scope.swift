import SwiftUI
import API
import UI
import Backport

extension Search {
    struct Scope: ViewModifier {
        var base: FindBy
        @Binding var refine: FindBy
        
        func body(content: Content) -> some View {
            if base.collectionId != 0 {
                content
                    .backport.searchScopes($refine.collectionId, activation: .onSearchPresentation) {
                        Text("Everywhere")
                            .tag(0)
                        
                        CollectionLabel(base.collectionId)
                            .labelStyle(.titleOnly)
                            .tag(base.collectionId)
                    }
            } else {
                content
            }
        }
    }
}
