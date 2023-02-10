import SwiftUI
import API
import UI

extension Search {
    struct Scope: ViewModifier {
        var base: FindBy
        @Binding var refine: FindBy
        var isActive: Bool
        
        func body(content: Content) -> some View {
            content
                .searchScopes($refine.collectionId) {
                    if base.collectionId != 0 {
                        Text("Everywhere")
                            .tag(0)
                        
                        CollectionLabel(base.collectionId)
                            .tag(base.collectionId)
                    }
                }
            
                .searchScopes(.onSearchActivation)
        }
    }
}
