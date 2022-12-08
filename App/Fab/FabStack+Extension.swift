import SwiftUI
import UI

extension FabStack {
    struct Extension: View {
        var body: some View {
            EmptyState("Add from apps") {
                Image(systemName: "puzzlepiece.extension")
            } actions: {
                Button("Install extension") {
                    
                }
            }
        }
    }
}
