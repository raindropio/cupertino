import SwiftUI
import API
import UI
import Common

struct BrowseList<H: View>: View {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var raindrops: RaindropsStore
    @EnvironmentObject private var app: AppRouter

    var find: FindBy
    var header: () -> H
    
    func action(_ id: Raindrop.ID) {
        if let raindrop = raindrops.state.item(id) {
            app.preview(raindrop)
        }
    }
    
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
            layout: layout,
            action: action
        )
    }
}

extension BrowseList where H == EmptyView {
    init(find: FindBy) {
        self.find = find
        self.header = { EmptyView() }
    }
}

extension BrowseList { fileprivate struct Memorized: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var selection = Set<Raindrop.ID>()
    @State private var edit: Raindrop?

    var find: FindBy
    var header: () -> H
    var view: CollectionView
    var layout: LazyStackLayout
    var action: (Raindrop.ID) -> Void

    var body: some View {
        LazyStack(
            layout,
            selection: $selection,
            action: action,
            contextMenu: { Menus(ids: $0, selection: $selection, edit: $edit) }
        ) {
            header()

            if isPhone {
                BrowseStatusBar(find: find)
            }
            
            Section {
                BrowseItems(
                    find: find,
                    view: view,
                    edit: $edit
                )
            } footer: {
                BrowseLoadMore(find: find)
            }
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
            .modifier(BrowseBulk(find: find, selection: $selection))
            .sheet(item: $edit, content: EditRaindropStack.init)
    }
}}
