import SwiftUI
import UI
import API
import Common
import Backport

struct BrowseItems: View {
    @EnvironmentObject private var r: RaindropsStore

    var find: FindBy
    var view: CollectionView
    @Binding var edit: Raindrop?

    var body: some View {
        if r.state.isEmpty(find) {
            Empty(find: find)
                .dropConsumer(to: find)
        } else {
            Memorized(
                find: find,
                items: r.state.items(find),
                view: view,
                sort: r.state.sort(find),
                edit: $edit
            )
        }
    }
}

extension BrowseItems {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.drop) private var drop
        
        var find: FindBy
        var items: [Raindrop]
        var view: CollectionView
        var sort: SortBy
        @Binding var edit: Raindrop?
        
        func reorder(_ id: Raindrop.ID, _ order: Int) {
            dispatch.sync(RaindropsAction.reorder(id, order: order))
        }
        
        func insert(_ order: Int, _ items: [NSItemProvider]) {
            drop?(items, find.collectionId)
        }
        
        func loadMore() async {
            try? await dispatch(RaindropsAction.more(find))
        }
        
        func render(_ item: Raindrop) -> some View {
            BrowseItem(find: find, raindrop: item, view: view)
                .swipeActions(edge: .leading) {
                    Link(destination: item.link) {
                        Label("Open", systemImage: "safari")
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button { edit = item } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                        .tint(.blue)

                    Button(role: .destructive) {
                        dispatch.sync(RaindropsAction.delete(item.id))
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                        .tint(.red)
                    
                    Backport.ShareLink(item: item.link)
                }
                .onDrag {
                    item.itemProvider
                }
        }
        
        var body: some View {
            DataSource(
                items,
                content: render,
                reorder: sort == .sort ? reorder : nil,
                insert: insert,
                insertOf: find.isSearching ? [] : addTypes,
                loadMore: loadMore
            )
        }
    }
}
