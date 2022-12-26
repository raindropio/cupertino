import SwiftUI
import API

extension CollectionEvents {
    struct Merge: View {
        @EnvironmentObject private var dispatch: Dispatcher
        var ids: Set<UserCollection.ID>

        var body: some View {
            Button("Merge", role: .destructive) {
                dispatch.sync(CollectionsAction.merge(ids, nested: false))
            }
            
            Button("Merge (including nested)", role: .destructive) {
                dispatch.sync(CollectionsAction.merge(ids, nested: true))
            }
        }
    }
}
