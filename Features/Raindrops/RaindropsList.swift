import SwiftUI
import API
import UI

struct RaindropsList<H: View>: View {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var raindrops: RaindropsStore

    var find: FindBy
    var header: () -> H
    
    var body: some View {
        let view = collections.state.view(find.collectionId)
        let layout: LazyStackLayout = {
            switch view {
            case .list, .simple: return .list
            case .grid: return .grid(250, false)
            case .masonry: return .grid(250, true)
            }
        }()
        
        Memorized(
            find: find,
            header: header,
            view: view,
            layout: layout
        )
    }
}

extension RaindropsList where H == EmptyView {
    init(find: FindBy) {
        self.find = find
        self.header = { EmptyView() }
    }
}

extension RaindropsList { fileprivate struct Memorized: View {
    @EnvironmentObject private var app: AppRouter
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var selection = Set<Raindrop.ID>()

    var find: FindBy
    var action: ((Raindrop.ID) -> Void)?
    var header: () -> H
    var view: CollectionView
    var layout: LazyStackLayout
    
    var body: some View {
        LazyStack(
            layout,
            selection: $selection,
            action: {
                app.push(.preview($0))
            }
        ) {
            header()

            if isPhone {
                RaindropsStatusBar(find: find)
            }
            
            Section {
                RaindropsItems(
                    find: find,
                    view: view
                )
            } footer: {
                RaindropsLoadMore(find: find)
            }
        } contextMenu: { _ in
            
        }
            .id(find)
            .listStyle(.plain)
            .refreshable {
                try? await dispatch(RaindropsAction.load(find))
            }
            .task(id: find, priority: .background) {
                try? await dispatch(RaindropsAction.load(find))
            }
            .modifier(Toolbar(find: find))
    }
}}
