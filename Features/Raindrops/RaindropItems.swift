import SwiftUI
import API
import UI

public struct RaindropItems: View {
    @EnvironmentObject private var r: RaindropsStore
    var find: FindBy
    
    public init(_ find: FindBy) {
        self.find = find
    }
    
    public var body: some View {
        if r.state.isEmpty(find) {
            EmptyRaindrops(find: find, status: r.state.status(find))
                .dropConsumer(to: find)
        } else {
            Memorized(
                find: find,
                items: r.state.items(find),
                sort: r.state.sort(find)
            )
        }
    }
}

extension RaindropItems { fileprivate struct Memorized: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.drop) private var drop
    
    var find: FindBy
    var items: [Raindrop]
    var sort: SortBy
    
    func reorder(_ id: Raindrop.ID, _ order: Int) {
        dispatch.sync(RaindropsAction.reorder(id, order: order))
    }
    
    func insert(_ order: Int, _ items: [NSItemProvider]) {
        drop?(items, find.collectionId)
    }
    
    func loadMore() async {
        try? await dispatch(RaindropsAction.more(find))
    }
    
    var body: some View {
        DataSource(
            items,
            content: RaindropItem.init,
            reorder: sort == .sort ? reorder : nil,
            insert: insert,
            insertOf: find.isSearching ? [] : addTypes,
            loadMore: loadMore
        )
    }
}}
