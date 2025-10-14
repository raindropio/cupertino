import SwiftUI
import API
import UI

public struct FiltersComposer: View {
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

extension FiltersComposer {
    fileprivate struct Memorized: View {
        @Binding var find: FindBy
        var tags: [Filter]
        var simple: [Filter]
        var created: [Filter]
        
        @Environment(\.dismiss) private var dismiss
        @State private var show = false
        
        private func toggle(_ item: Filter) {
            if find.filters.contains(item) {
                find.filters = find.filters.filter { $0 != item }
            } else {
                find.filters.append(item)
            }
        }
        
        private var selectedCreated: Binding<Filter?> {
            .init(
                get: {
                    find.filters.first {
                        if case .created = $0.kind {
                            return true
                        }
                        return false
                    }
                },
                set: {
                    find.filters = find.filters.filter {
                        if case .created = $0.kind {
                            return false
                        }
                        return true
                    }
                    if let filter = $0 {
                        find.filters.append(filter)
                    }
                }
            )
        }
        
        private func activeBadge(_ item: Filter) -> Text {
            let active = find.filters.contains(item)
            
            return .init(active ? "✓" : String(item.count))
                .foregroundColor(active ? .accentColor : .secondary)
                .fontWeight(active ? .semibold : nil)
        }
                
        var body: some View {
            NavigationStack {
                List {
                    Picker("Created", systemImage: "calendar", selection: selectedCreated) {
                        Text("Any time")
                            .tag(nil as Filter?)
                        
                        ForEach(created) { item in
                            Text(item.title)
                                .tag(item)
                        }
                    }
                        .disabled(created.isEmpty)
                    
                    if !created.isEmpty {
                        Section {
                            ForEach(simple) { item in
                                Button {
                                    toggle(item)
                                } label: {
                                    Label {
                                        Text(item.title).foregroundColor(.primary)
                                    } icon: {
                                        Image(systemName: item.systemImage)
                                    }
                                }
                                .badge(activeBadge(item))
                                .listItemTint(item.color)
                            }
                        }
                    }
                    
                    if !tags.isEmpty {
                        Section("Tags") {
                            ForEach(tags) { item in
                                Button {
                                    toggle(item)
                                } label: {
                                    Label {
                                        Text(item.title).foregroundColor(.primary)
                                    } icon: {
                                        Image(systemName: item.systemImage)
                                    }
                                }
                                .badge(activeBadge(item))
                            }
                        }
                    }
                }
                .symbolVariant(.fill)
                .navigationTitle("Filter")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        if !find.filters.isEmpty {
                            Button("Reset") {
                                find.filters = []
                            }
                        }
                    }
                    
                    DoneToolbarItem()
                }
                .presentationDetents(UIDevice.current.userInterfaceIdiom == .phone ? [.medium, .large] : [.large])
                .animation(.default, value: find.filters.count)
            }
        }
    }
}
