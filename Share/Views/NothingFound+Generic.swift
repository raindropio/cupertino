import SwiftUI
import UI
import API

extension NothingFound {
    struct Generic: View {
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            EmptyState("Nothing found", message: "Unfortunately we can't recognize shared content") {
                Image(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
                    .foregroundStyle(.red)
            } actions: {
                Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
            }
        }
    }
}
