import SwiftUI
import API

extension _CollectionSheetsModifier {
    struct Delete: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var c: CollectionsStore

        var ids: Set<UserCollection.ID>
        
        var haveChildrens: Bool {
            ids.contains {
                !c.state.childrens(of: $0).isEmpty
            }
        }

        var body: some View {
            Button("Delete", role: .destructive) {
                dispatch.sync(CollectionsAction.deleteMany(ids, nested: false))
            }
            
            if haveChildrens {
                Button("Delete (including nested)", role: .destructive) {
                    dispatch.sync(CollectionsAction.deleteMany(ids, nested: true))
                }
            }
        }
    }
}
