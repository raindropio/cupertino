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
            items: f.state.tags(),
            isExpanded: f.state.config.tagsHidden
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
        @EnvironmentObject private var dispatch: Dispatcher
        
        var tag: (Filter) -> T
        var items: [Filter]
        var isExpanded: Bool
        
        func toggle() {
            dispatch.sync(FiltersAction.toggle)
        }
        
        func sortByName() {
            Task {
                try? await dispatch(FiltersAction.sort(.title))
                try? await dispatch(FiltersAction.reload())
            }
        }
        
        func sortByCount() {
            Task {
                try? await dispatch(FiltersAction.sort(.count))
                try? await dispatch(FiltersAction.reload())
            }
        }

        var body: some View {
            if !items.isEmpty {
                DisclosureSection(
                    "Tags",
                    isExpanded: isExpanded,
                    toggle: toggle
                ) {
                    ForEach(items) { item in
                        FilterRow(item)
                            .swipeActions {
                                TagsMenu(Set([item]))
                            }
                            .backport.tag(tag(item))
                    }
                } menu: {
                    Button("Sort by name", action: sortByName)
                    Button("Sort by count", action: sortByCount)
                }
            }
        }
    }
}
