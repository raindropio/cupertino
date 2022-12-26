import SwiftUI
import API
import UI
import Backport

struct TagsSection<T: Hashable>: View {
    @EnvironmentObject private var f: FiltersStore
    var tag: (Filter) -> T
    
    var body: some View {
        Memorized(
            tag: tag,
            items: f.state.tags()
        )
    }
}

extension TagsSection where T == String {
    init() {
        self.tag = { $0.title }
    }
}

extension TagsSection where T == FindBy {
    init() {
        self.tag = { .init($0) }
    }
}

extension TagsSection {
    fileprivate struct Memorized: View {
        var tag: (Filter) -> T
        var items: [Filter]

        var body: some View {
            if !items.isEmpty {
                Section {
                    ForEach(items) { item in
                        FilterRow(item)
                            .swipeActions {
                                TagsMenu(Set([item]))
                            }
                            .backport.tag(tag(item))
                    }
                } header: {
                    Text("Tags")
                }
            }
        }
    }
}
