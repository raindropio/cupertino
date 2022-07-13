import SwiftUI
import API

struct Browse: View {
    @EnvironmentObject private var router: Router
    @State private var selection = Set<Raindrop>()

    var collection: Collection
    var query: String
    
    var body: some View {
        RaindropsView(selection: $selection) {
            if !collection.isSystem {
                ChildrenView(parent: collection) {
                    Route.browse($0, "")
                }
            }
        }
            .contextAction(forSelectionType: Raindrop.self) {
                if $0.count == 1, let raindrop = $0.first {
                    router.path.append(.preview(raindrop))
                }
            }
            .navigationTitle(collection.title)
    }
}
