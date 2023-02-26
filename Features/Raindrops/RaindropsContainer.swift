import SwiftUI
import API
import UI

public struct RaindropsContainer<C: View>: View {
    @EnvironmentObject private var c: CollectionsStore
    @EnvironmentObject private var cfg: ConfigStore

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
    
    private var coverWidth: Double {
        194 + (Double(cfg.state.raindrops.coverSize) * 30)
    }
    
    private var layout: LazyStackLayout {
        switch view {
        case .list, .simple: return .list
        case .grid: return .grid(coverWidth, false)
        case .masonry: return .grid(coverWidth, true)
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
                find: find,
                view: view,
                hide: cfg.state.raindrops.hide[view] ?? .init(),
                coverRight: cfg.state.raindrops.coverRight,
                coverWidth: coverWidth
            ))
    }
}

extension RaindropsContainer { fileprivate struct Memorized: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.openDeepLink) private var openDeepLink

    var find: FindBy
    @Binding var selection: Set<Raindrop.ID>
    var layout: LazyStackLayout
    var content: () -> C
    
    var body: some View {
        LazyStack(
            layout,
            selection: $selection,
            action: { openDeepLink?(.raindrop(.open(find, $0))) },
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
