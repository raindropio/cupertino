import SwiftUI
import API
import UI
import Common

extension GlobalSearch {
    struct Suggestions: View {
        @EnvironmentObject private var c: CollectionsStore
        @EnvironmentObject private var f: FiltersStore
        @EnvironmentObject private var r: RecentStore
        
        var find: FindBy
        
        var body: some View {
            Memorized(
                find: find,
                collections: (find.collectionId == 0 && find.filters.isEmpty) ? c.state.find(find.text) : [],
                recent: r.state.search(find),
                completion: f.state.completion(find),
                simple: f.state.simple(find),
                tags: f.state.tags(find)
            )
        }
    }
}

extension GlobalSearch.Suggestions {
    fileprivate struct Memorized: View {
        var find: FindBy
        var collections: [UserCollection]
        var recent: [String]
        var completion: [Filter]
        var simple: [Filter]
        var tags: [Filter]
        
        var body: some View {
            Group {
                Collections(items: collections)
                Recent(items: recent)
                if #available(iOS 16, *) {
                    Segment(title: "Suggestions", items: completion)
                }
                Segment(title: "Filters", items: simple)
                Segment(title: "\(tags.count) tags", items: tags)
            }
                .labelStyle(.searchSuggestion)
        }
    }
}

extension GlobalSearch.Suggestions {
    fileprivate struct Collections: View {
        @EnvironmentObject private var app: AppRouter
        var items: [UserCollection]
        
        var body: some View {
            if !items.isEmpty {
                Section("Found \(items.count) collections") {
                    ForEach(items) { item in
                        Button {
                            app.browse(item)
                        } label: {
                            UserCollectionLabel(item, withLocation: true)
                        }
                    }
                }
            }
        }
    }
}

extension GlobalSearch.Suggestions {
    fileprivate struct Segment: View {
        var title: String
        var items: [Filter]
        
        var body: some View {
            if !items.isEmpty {
                Section(title) {
                    ForEach(items) {
                        FilterRow($0)
                            .equatable()
                            .backport.searchCompletion($0)
                    }
                }
            }
        }
    }
}

extension GlobalSearch.Suggestions {
    fileprivate struct Recent: View {
        @EnvironmentObject private var dispatch: Dispatcher
        var items: [String]
        
        var body: some View {
            if !items.isEmpty {
                Section {
                    ForEach(items, id: \.self) {
                        Label($0, systemImage: "clock.arrow.circlepath")
                            .searchCompletion($0)
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
}
