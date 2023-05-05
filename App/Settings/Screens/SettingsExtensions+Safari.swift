import SwiftUI
import UI

extension SettingsExtensions {
    struct Safari: View {
        var body: some View {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Safari Extension", systemImage: "safari")
                        .fontWeight(.medium)
                    
                    Text("Desktop-class experience. Save all open tabs, add highlights and quickly access your bookmarks")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .labelStyle(.sidebar)
                    .listItemTint(.teal)
                
                Link("Enable", destination: URL(string: "https://help.raindrop.io/mobile-app#share-ios-safari")!)
            }
        }
    }
}
