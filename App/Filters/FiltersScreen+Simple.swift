import SwiftUI
import API
import Common
import UI

extension FiltersScreen {
    struct Simple: View {
        @Environment(\.editMode) private var editMode
        @EnvironmentObject private var app: AppRouter
        var items: [Filter]

        var body: some View {
            Section {} header: {
                if !items.isEmpty && editMode?.wrappedValue != .active {
                    LazyVGrid(
                        columns: [.init(
                            .adaptive(minimum: 140),
                            spacing: 16
                        )],
                        spacing: 16
                    ) {
                        ForEach(items) { filter in
                            Button {
                                app.browse(filter)
                            } label: {
                                FilterRow(filter)
                                    .frame(height: 32)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                                .tint(filter.color.opacity(0.7))
                                .foregroundStyle(filter.color)
                        }
                    }
                        .id(items.count)
                        .font(.body)
                        .buttonStyle(.bordered)
                        .textCase(.none)
                        .clearSection()
                        .padding(.top, 8)
                }
            }
        }
    }
}
