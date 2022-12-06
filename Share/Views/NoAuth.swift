import SwiftUI
import UI

struct NoAuth: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        EmptyState("Login required", message: "Please open Raindrop.io app to get started") {
            Image(systemName: "person.crop.circle")
        } actions: {
            Button("OK", action: dismiss.callAsFunction)
        }
            .backport.presentationDetents([.medium])
            .presentationUndimmed(.medium)
    }
}
