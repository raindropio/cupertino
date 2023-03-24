import SwiftUI
import UI

struct NoAuth: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        EmptyState("Need to log in", message: Text("Please open **Raindrop.io** app to get started")) {
            Image(systemName: "person.crop.circle")
                .foregroundStyle(.yellow)
        } actions: {
            Button("OK", role: .cancel, action: dismiss.callAsFunction)
        }
            .presentationDetents([.medium])
            #if canImport(UIKit)
            .frame(idealWidth: 400, idealHeight: 400)
            #else
            .frame(width: 400)
            .fixedSize()
            #endif
    }
}
