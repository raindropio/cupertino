import SwiftUI
import API
import Common
import UI

extension FiltersScreen {
    struct Tags: View {
        @Environment(\.filtersEditModeAction) private var action
        
        var items: [Filter]

        private func renameButton(_ item: Filter) -> some View {
            Button {
                action?.wrappedValue = .rename(item)
            } label: {
                Label("Rename", systemImage: "pencil")
            }
                .tint(.accentColor)
        }
        
        private func deleteButton(_ item: Filter) -> some View {
            Button {
                action?.wrappedValue = .delete(Set([item]))
            } label: {
                Label("Delete", systemImage: "trash")
            }
                .tint(.red)
        }

        var body: some View {
            if items.isEmpty {
                EmptyState("No tags") {
                    Image(systemName: "number")
                } actions: {
                    SafariLink("Learn more", destination: URL(string: "https://help.raindrop.io/tags")!)
                }
                    .frame(maxWidth: .infinity)
                    .clearSection()
            } else {
                Section {
                    ForEach(items) { tag in
                        FilterRow(tag)
                            .badge(tag.count)
                            .swipeActions {
                                renameButton(tag)
                                deleteButton(tag)
                            }
                            .backport.tag(tag)
                    }
                } header: {
                    if !items.isEmpty {
                        Text("\(items.count) tags")
                    }
                }
            }
        }
    }
}
