import SwiftUI
import UI
import API
import Common

struct BrowseItems: View {
    @EnvironmentObject private var r: RaindropsStore

    var find: FindBy
    var view: CollectionView
    @Binding var edit: Raindrop?

    var body: some View {
        if r.state.isEmpty(find) {
            Empty(find: find)
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
        
        var find: FindBy
        var items: [Raindrop]
        var view: CollectionView
        var sort: SortBy
        @Binding var edit: Raindrop?
        
        func reorder(_ id: Raindrop.ID, _ order: Int) {
            dispatch.sync(RaindropsAction.reorder(id, order: order))
        }
        
        func loadMore() async {
            try? await dispatch(RaindropsAction.more(find))
        }
        
        func render(_ item: Raindrop) -> some View {
            RaindropRow(item, view: view)
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

                    Button {
                        
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                        .tint(.red)
                    
                    ShareLink(item: item.link)
                }
                .id(item.id)
        }
        
        var body: some View {
            DataSource(
                items,
                content: render,
                reorder: sort == .sort ? reorder : nil,
                loadMore: loadMore
            )
        }
    }
}
