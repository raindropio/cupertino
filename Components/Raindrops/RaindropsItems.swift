import SwiftUI
import UI
import API

struct RaindropsItems: View {
    @EnvironmentObject private var r: RaindropsStore

    var find: FindBy
    var view: CollectionView
    
    var body: some View {
        if r.state.isEmpty(find) {
            Empty(find: find)
        } else {
            Memorized(
                find: find,
                items: r.state.items(find),
                view: view
            )
        }
    }
}

extension RaindropsItems {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        
        var find: FindBy
        var items: [Raindrop]
        var view: CollectionView
        
        var body: some View {
            DataSource(items) { item in
                RaindropItem(raindrop: item, view: view)
                    .swipeActions(edge: .leading) {
                        Link(destination: item.link) {
                            Label("Open", systemImage: "safari")
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                        } label: {
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
            } loadMore: {
                try? await dispatch(RaindropsAction.more(find))
            }
        }
    }
}
