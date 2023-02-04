import SwiftUI
import API
import Backport

public struct Spotlight {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var find: FindBy = .init()
    @State private var focused = true
    
    public init() {}
}

extension Spotlight: View {
    public var body: some View {
        List {
            Group {
                Group {
                    SuggestedFilters(find: $find)
                    RecentSearches(find: find)
                    //TODO: recent collections/bookmarks
                    SuggestedCompletion(find: find)
                    FoundCollections(find: find)
                }
                .listRowSeparator(.hidden, edges: .bottom)
                
                FoundRaindrops(find: find)
            }
            .listRowBackground(Color.clear)
            
            //otherwise solid list bg when empty
            Color.clear.clearSection()
        }
            //appearance
            .listStyle(.plain)
            .environment(\.defaultMinListHeaderHeight, 40)
            .symbolVariant(.fill)
            .controlSize(.small)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(Animations(find: find))
            //editing
            .collectionsEvent()
            .tagsEvent()
            //search
            .modifier(Cancel(focused: $focused))
            .modifier(SearchBar(find: $find, focused: $focused))
            .task(id: find, priority: .background, debounce: 0.5) {                
                try? await dispatch(
                    [
                        FiltersAction.reload(find),
                        RecentAction.reload(find)
                    ] + (
                        find.isSearching ? [RaindropsAction.load(find)] : []
                    )
                )
            }
    }
}
