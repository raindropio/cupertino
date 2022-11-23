import SwiftUI
import UI
import API

struct BrowseStatusBar: View {
    @Environment(\.editMode) private var editMode

    var find: FindBy

    var body: some View {
        LabeledContent {
            HStack {
                BrowseSortButton(find: find)
                    .labelStyle(.titleOnly)
                BrowseViewButton(find: find)
                    .labelStyle(.iconOnly)
                    .menuIndicator(.hidden)
            }
                .labelsHidden()
                .pickerStyle(.menu)
                .lineLimit(1)
                .layoutPriority(1)
        } label: {
            Total(find: find)
        }
            .scenePadding(.horizontal)
            .clearSection()
            .disabled(editMode?.wrappedValue == .active)
    }
}

extension BrowseStatusBar {
    fileprivate struct Total: View {
        @EnvironmentObject private var raindrops: RaindropsStore
        var find: FindBy
        
        var body: some View {
            let total = raindrops.state.total(find)
            
            (
                Text(total, format: .number) +
                Text(" bookmarks")
            )
            .lineLimit(1)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .opacity(total > 0 ? 1 : 0)
        }
    }
}
