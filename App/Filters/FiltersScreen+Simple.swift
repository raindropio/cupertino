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
            if !items.isEmpty && editMode?.wrappedValue != .active {
                GroupBox {
                    ForEach(items) { filter in
                        Button {
                            app.browse(filter)
                        } label: {
                            FilterRow(filter)
                        }
                    }
                }
                    .groupBoxStyle(.board)
            }
        }
    }
}
