import SwiftUI
import UI

extension SettingsExtensions {
    struct Action: View {
        var body: some View {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Add to Unsorted Action", systemImage: "icloud")
                        .fontWeight(.medium)
                    
                    Text("Quickly add new content to unsorted collection. No questions asked")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .labelStyle(.sidebar)
                    .listItemTint(.pink)
                
                SafariLink("Enable", destination: URL(string: "https://help.raindrop.io/mobile-app#share-ios-safari")!)
            }
        }
    }
}
