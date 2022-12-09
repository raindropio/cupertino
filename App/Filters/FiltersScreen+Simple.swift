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
                    WStack {
                        ForEach(items) { filter in
                            Button {
                                app.browse(filter)
                            } label: {
                                FilterRow(filter)
                            }
                                .tint(filter.color.opacity(0.7))
                                .foregroundStyle(filter.color)
                        }
                    }
                        .id(items.count) //wstack baggy
                        .font(.body)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .textCase(.none)
                        .clearSection()
                        .padding(.top, 8)
                }
            }
        }
    }
}
