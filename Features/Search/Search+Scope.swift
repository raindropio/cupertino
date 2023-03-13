import SwiftUI
import API
import UI
import Backport

extension Search {
    struct Scope: ViewModifier {
        var base: FindBy
        @Binding var refine: FindBy
        
        func body(content: Content) -> some View {
            content
                .backport.searchScopes($refine.collectionId, activation: .onSearchPresentation) {
                    if base.collectionId != 0 {
                        Text("Everywhere")
                            .tag(0)
                        
                        CollectionLabel(base.collectionId)
                            .tag(base.collectionId)
                    }
                }
        }
    }
}
