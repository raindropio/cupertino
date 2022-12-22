import SwiftUI
import API
import Common
import Backport
import UI

struct FiltersScreen: View {
    @EnvironmentObject private var f: FiltersStore
    @State private var search = ""
    
    func searched(_ items: [Filter]) -> [Filter] {
        guard !search.isEmpty else { return items }
        return items.filter {
            $0.title.localizedLowercase.contains(search.localizedLowercase)
        }
    }

    var body: some View {
        Memorized(
            search: $search,
            simple: searched(f.state.simple()),
            tags: searched(f.state.tags().filter { $0.kind != .notag })
        )
            .animation(.default, value: search)
    }
}

extension FiltersScreen {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var selection = Set<Filter>()
        
        @Binding var search: String
        var simple: [Filter]
        var tags: [Filter]

        var body: some View {
            Backport.List(selection: $selection) {
                Simple(items: simple)
                Tags(items: tags)
            }
                .refreshable {
                    try? await dispatch(FiltersAction.reload())
                }
                .reload {
                    try? await dispatch(FiltersAction.reload())
                }
                .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: search) { _ in selection = .init() }
                .navigationTitle("Filters & Tags")
                .modifier(FiltersEditMode(selection: $selection))
                .fixEditMode()
        }
    }
}
