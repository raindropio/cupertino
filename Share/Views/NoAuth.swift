import SwiftUI
import UI

struct NoAuth: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        EmptyState("Login required", message: "Please open Raindrop.io app to get started") {
            Image(systemName: "person.crop.circle")
                .foregroundStyle(.yellow)
        } actions: {
            Button("OK", role: .cancel, action: dismiss.callAsFunction)
        }
            .presentationDetents([.medium])
            .presentationUndimmed(.medium)
    }
}
