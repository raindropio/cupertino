import SwiftUI
import UI
import API

struct RaindropsStatusBar: View {
    var find: FindBy

    var body: some View {
        LabeledContent {
            HStack {
                RaindropsSortButton(find: find)
                    .labelStyle(.titleOnly)
                RaindropsViewButton(find: find)
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
    }
}

extension RaindropsStatusBar {
    fileprivate struct Total: View {
        @EnvironmentObject private var raindrops: RaindropsStore
        var find: FindBy
        
        var body: some View {
            (
                Text(raindrops.state.total(find), format: .number) +
                Text(" bookmarks")
            )
            .lineLimit(1)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
        }
    }
}
