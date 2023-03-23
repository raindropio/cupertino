import SwiftUI
import UI
import API

extension NothingFound {
    struct AddText: View {
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            EmptyState(
                "Add text?",
                message:
                    Text("Please follow this steps instead: \n\n") +
                Text("1. Select text in Safari web-page.\n") +
                Text("2. Tap ") + Text(Image(systemName: "square.and.arrow.up")) + Text(" button in **Safari toolbar** (not in selection popover).\n") +
                Text("3. Tap ") + Text(Image(systemName: "cloud.fill")) + Text(" Raindrop.io")
            ) {
                Image(systemName: Filter.Kind.highlights.systemImage)
                    .foregroundStyle(Filter.Kind.highlights.color)
            } actions: {
                HStack {
                    SafariLink("Learn more", destination: URL(string: "https://help.raindrop.io/highlights#add")!)
                    
                    Button("OK, got it", role: .cancel, action: dismiss.callAsFunction)
                        .buttonStyle(.borderedProminent)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
