import SwiftUI
import API
import UI

struct RecentSearches: View {
    @EnvironmentObject private var r: RecentStore
    var find: FindBy

    var body: some View {
        Memorized(items: r.state.search(find))
    }
}

extension RecentSearches {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @AppStorage("recent-expanded") private var isExpanded = true
        
        var items: [String]
        
        var body: some View {
            if !items.isEmpty {
                DisclosureSection("Recent", isExpanded: $isExpanded) {
                    ForEach(items, id: \.self) {
                        Label($0, systemImage: "clock.arrow.circlepath")
                            .searchCompletion($0)
                    }
                } actions: {
                    Button("Clear") {
                        dispatch.sync(RecentAction.clearSearch)
                    }
                }
            }
        }
    }
}
