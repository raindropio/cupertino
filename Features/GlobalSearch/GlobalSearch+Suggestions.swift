import SwiftUI
import API
import UI

extension GlobalSearch {
    struct Suggestions: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var f: FiltersStore
        @EnvironmentObject private var r: RecentStore
        
        @Binding var find: FindBy
        
        func body(content: Content) -> some View {
            content
                .task(id: find, priority: .background) {
                    try? await dispatch(
                        FiltersAction.reload(find),
                        RecentAction.reload(find)
                    )
                }
                .modifier(
                    Memorized(
                        find: find,
                        recent: r.state.search(find),
                        completion: f.state.completion(find),
                        simple: f.state.simple(find),
                        tags: f.state.tags(find)
                    )
                )
        }
    }
}

extension GlobalSearch.Suggestions {
    fileprivate struct Memorized: ViewModifier {        
        var find: FindBy
        var recent: [String]
        var completion: [Filter]
        var simple: [Filter]
        var tags: [Filter]
        
        func body(content: Content) -> some View {
            content
//                .animation(
//                    .default.speed(1),
//                    value: recent.count + collections.count + completion.count + simple.count + tags.count
//                )
                .searchSuggestions {
                    Group {
                        SearchCollections(find: find)
                        Recent(items: recent)
                        Segment(title: "Suggestions", items: completion)
                        Segment(title: "Filters", items: simple)
                        Segment(title: "\(tags.count) tags", items: tags)
                    }
                        .labelStyle(.searchSuggestion)
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
                        FilterItem($0)
                            .equatable()
                            .searchCompletion($0)
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
