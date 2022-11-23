import SwiftUI
import API
import UI

extension BrowseBulk {
    struct Delete: View {
        @EnvironmentObject private var dispatch: Dispatcher
        
        //props
        var pick: RaindropsPick
        var action: ( @escaping () async throws -> Void ) -> Void
        
        //do work
        private func delete() {
            action {
                try await dispatch(RaindropsAction.deleteMany(pick))
            }
        }
        
        var body: some View {
            ConfirmButton(role: .destructive) {
                Button("Delete \(BrowseBulk.title(pick))", role: .destructive, action: delete)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}
