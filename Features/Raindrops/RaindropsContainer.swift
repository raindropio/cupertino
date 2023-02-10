import SwiftUI
import API
import UI

public struct RaindropsContainer<C: View>: View {
    @EnvironmentObject private var c: CollectionsStore
    
    var find: FindBy
    @Binding var selection: Set<Raindrop.ID>
    var content: () -> C
    
    public init(
        _ find: FindBy,
        selection: Binding<Set<Raindrop.ID>>,
        @ViewBuilder content: @escaping () -> C
    ) {
        self.find = find
        self._selection = selection
        self.content = content
    }
    
    private var view: CollectionView {
        c.state.view(find.collectionId)
    }
    
    private var layout: LazyStackLayout {
        switch view {
        case .list, .simple: return .list
        case .grid: return .grid(250, false)
        case .masonry: return .grid(250, true)
        }
    }
    
    public var body: some View {
        Memorized(
            find: find,
            selection: $selection,
            layout: layout,
            content: content
        )
            .environment(\.raindropsContainer, .init(
                collectionId: find.collectionId,
                view: view
            ))
    }
}

extension RaindropsContainer { fileprivate struct Memorized: View {
    @EnvironmentObject private var event: RaindropsEvent
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var itemLinkService: ItemLinkService<Raindrop>

    var find: FindBy
    @Binding var selection: Set<Raindrop.ID>
    var layout: LazyStackLayout
    var content: () -> C
    
    var body: some View {
        LazyStack(
            layout,
            selection: $selection,
            action: { itemLinkService(id: $0) },
            contextMenu: RaindropsMenu,
            content: content
        )
            .raindropsAnimation()
            .listStyle(.plain)
            .refreshable {
                try? await dispatch(RaindropsAction.load(find))
            }
            .reload(id: find, priority: .background) {
                try? await dispatch(RaindropsAction.load(find))
            }
    }
}}
