import SwiftUI
import API
import Common
import Backport

fileprivate var previous: FindBy?

struct Spotlight: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var find: FindBy = previous ?? .init()
    
    var body: some View {
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
            .collectionEvents()
            .tagEvents()
            //react to events
            .dismissOnSearchCancel()
            .modifier(Events(find: find))
            //search
            .modifier(SearchBar(find: $find))
            .task(id: find, priority: .background, debounce: 0.5) {
                previous = find
                
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
