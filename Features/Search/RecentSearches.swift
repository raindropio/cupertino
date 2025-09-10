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
        var items: [String]
        
        var body: some View {
            Section {
                ForEach(items, id: \.self) { item in
                    Label(item, systemImage: "clock.arrow.circlepath")
                        .searchCompletion(item)
                }
            } header: {
                if !items.isEmpty {
                    HStack {
                        Text("Recent")
                        Spacer()
                        Button("Clear") {
                            dispatch.sync(RecentAction.clearSearch)
                        }
                    }
                }
            }
        }
    }
}
