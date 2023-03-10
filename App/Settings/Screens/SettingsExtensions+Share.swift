import SwiftUI
import UI

extension SettingsExtensions {
    struct Share: View {
        var body: some View {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Share Extension", systemImage: "square.and.arrow.up")
                        .fontWeight(.medium)
                    
                    Text("Recommended way to add new content from browser and apps")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .labelStyle(.sidebar)
                    .listItemTint(.blue)
                
                SafariLink("Enable", destination: URL(string: "https://help.raindrop.io/mobile-app#share-ios")!)
            }
        }
    }
}
