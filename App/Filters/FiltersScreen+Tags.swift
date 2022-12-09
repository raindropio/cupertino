import SwiftUI
import API
import Common
import UI

extension FiltersScreen {
    struct Tags: View {
        @Environment(\.filtersEditModeAction) private var action
        
        var items: [Filter]
        
        private func onDelete(_ offsets: IndexSet) {
            action?.wrappedValue = .delete(
                Set(
                    offsets.map { items[$0] }
                )
            )
        }

        var body: some View {
            Section {
                ForEach(items) { tag in
                    if tag.kind != .notag {
                        FilterRow(tag)
                            .badge(tag.count)
                            .backport.tag(tag)
                    }
                }
                    .onDelete(perform: onDelete)
            } header: {
                if !items.isEmpty {
                    Text("\(items.count) tags")
                }
            }
        }
    }
}
