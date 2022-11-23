import SwiftUI
import API

extension BrowseBulk {
    struct Done: View {
        @Environment(\.editMode) private var editMode

        var body: some View {
            Button("Done", role: .cancel) {
                withAnimation {
                    editMode?.wrappedValue = .inactive
                }
            }
                .fontWeight(.semibold)
        }
    }
}
