import SwiftUI
import API
import UI

public struct FilterRaindropsButton: View {
    @EnvironmentObject private var f: FiltersStore
    @EnvironmentObject private var dispatch: Dispatcher

    @Binding var find: FindBy
    
    public init(_ find: Binding<FindBy>) {
        self._find = find
    }

    public var body: some View {
        let scoped = find.excludingFilters()
        
        Memorized(
            find: $find,
            tags: f.state.tags(scoped),
            simple: f.state.simple(scoped),
            created: f.state.created(scoped)
        )
        .task(id: find, priority: .background, debounce: 0.3) {
            try? await dispatch(FiltersAction.reload(scoped))
        }
    }
}

extension FilterRaindropsButton {
    fileprivate struct Memorized: View {
        @Binding var find: FindBy
        var tags: [Filter]
        var simple: [Filter]
        var created: [Filter]
        
        private func toggle(_ item: Filter) -> Binding<Bool> {
            return .init(
                get: { find.filters.contains(item) },
                set: {
                    if $0 { find.filters.append(item) }
                    else { find.filters = find.filters.filter { $0 != item } }
                }
            )
        }
        
        var body: some View {
            Menu("Filter", systemImage: find.filters.isEmpty ? "line.3.horizontal.decrease" : "line.3.horizontal.decrease.circle.fill") {
                if !find.filters.isEmpty {
                    Button("Clear filters", systemImage: "xmark", role: .destructive) {
                        find.filters = []
                    }
                }
                
                if !created.isEmpty {
                    Section("Attributes") {
                        ForEach(simple) { item in
                            Toggle(isOn: toggle(item)) {
                                FilterRow(item)
                            }
                            .tint(item.color)
                            .listItemTint(item.color)
                        }
                    }
                }
                
                if !tags.isEmpty {
                    Section("Tags") {
                        ForEach(tags) { item in
                            Toggle(isOn: toggle(item)) {
                                FilterRow(item)
                            }
                        }
                    }
                }
                
                if !created.isEmpty {
                    Section("Creation date") {
                        ForEach(created) { item in
                            Toggle(isOn: toggle(item)) {
                                FilterRow(item)
                            }
                        }
                    }
                }
            }
                .tint(find.filters.isEmpty ? nil : .accentColor)
                .help("Filter")
        }
    }
}
