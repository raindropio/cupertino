import SwiftUI
import UI

struct ProFeatures: View {
    var body: some View {
        Feature(
            systemImage: "magnifyingglass.circle",
            title: "Full-Text Search",
            description: "Search through the entire content of every page and PDF",
            link: URL(string: "https://help.raindrop.io/using-search#full-text-search")!
        )
            .listItemTint(.indigo)
        
        Feature(
            systemImage: "lock.square",
            title: "Permanent Library",
            description: "Even if a page you’ve saved is taken down, you’ll still have a copy of it",
            link: URL(string: "https://help.raindrop.io/using-search#full-text-search")!
        )
            .listItemTint(.green)
        
        Feature(
            systemImage: "folder.circle",
            title: "Nested Collections",
            description: "Create collection inside of a collection",
            link: URL(string: "https://help.raindrop.io/collections#nested-collections")!
        )
            .listItemTint(.red)
        
        Feature(
            systemImage: "message.circle",
            title: "Annotations",
            description: "Add notes (annotations) to your highlights",
            link: URL(string: "https://help.raindrop.io/highlights")!
        )
            .listItemTint(.orange)
        
        Feature(
            systemImage: "hand.raised.square",
            title: "Duplicate Finder",
            description: "Find duplicate bookmarks and wipe them away",
            link: URL(string: "https://help.raindrop.io/using-search#duplicates")!
        )
            .listItemTint(.purple)
        
        Feature(
            systemImage: "exclamationmark.square",
            title: "Broken Links Finder",
            description: "Find broken links and wipe them away",
            link: URL(string: "https://help.raindrop.io/using-search#broken-links")!
        )
            .listItemTint(.indigo)
        
        Feature(
            systemImage: "icloud.circle",
            title: "Automatic Backups",
            description: "Daily backups of your data",
            link: URL(string: "https://help.raindrop.io/backups#automatic")!
        )
            .listItemTint(.green)
        
        Feature(
            systemImage: "paperclip.circle",
            title: "More Space",
            description: "Upload 10 Gb of files each month",
            link: URL(string: "https://help.raindrop.io/limitations")!
        )
            .listItemTint(.orange)
    }
}

extension ProFeatures {
    struct Feature: View {
        var systemImage: String
        var title: String
        var description: String
        var link: URL
        
        var body: some View {
            Label {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.headline)
                        
                        Text(description)
                    }
                    
                    SafariLink("Learn more", destination: link)
                        .font(.callout)
                }
                    .padding(.vertical, 8)
            } icon: {
                Image(systemName: systemImage)
                    .font(.title)
                    .symbolVariant(.fill)
            }
        }
    }
}
