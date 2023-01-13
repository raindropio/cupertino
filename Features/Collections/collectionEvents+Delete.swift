import SwiftUI
import API

extension CollectionEvents {
    struct Delete: View {
        @EnvironmentObject private var dispatch: Dispatcher
        var ids: Set<UserCollection.ID>

        var body: some View {
            Button("Delete", role: .destructive) {
                dispatch.sync(CollectionsAction.deleteMany(ids, nested: false))
            }
            
            Button("Delete (including nested)", role: .destructive) {
                dispatch.sync(CollectionsAction.deleteMany(ids, nested: true))
            }
        }
    }
}
