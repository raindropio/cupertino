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
            .tint(.indigo)
        
        Feature(
            systemImage: "bell.square",
            title: "Reminders",
            description: "Alert you about your most time-sensitive bookmarks",
            link: URL(string: "https://help.raindrop.io/reminders")!
        )
            .tint(.red)
        
        Feature(
            systemImage: "lock.square",
            title: "Permanent Library",
            description: "Even if a page you’ve saved is taken down, you’ll still have a copy of it",
            link: URL(string: "https://help.raindrop.io/using-search#full-text-search")!
        )
            .tint(.green)
        
        Feature(
            systemImage: "message.circle",
            title: "Annotations",
            description: "Add notes (annotations) to your highlights",
            link: URL(string: "https://help.raindrop.io/highlights")!
        )
            .tint(.orange)
        
        Feature(
            systemImage: "hand.raised.square",
            title: "Duplicate Finder",
            description: "Find duplicate bookmarks and wipe them away",
            link: URL(string: "https://help.raindrop.io/using-search#duplicates")!
        )
            .tint(.purple)
        
        Feature(
            systemImage: "exclamationmark.square",
            title: "Broken Links Finder",
            description: "Find broken links and wipe them away",
            link: URL(string: "https://help.raindrop.io/using-search#broken-links")!
        )
            .tint(.indigo)
        
        Feature(
            systemImage: "icloud.circle",
            title: "Automatic Backups",
            description: "Daily backups of your data",
            link: URL(string: "https://help.raindrop.io/backups#automatic")!
        )
            .tint(.green)
        
        Feature(
            systemImage: "paperclip.circle",
            title: "More Space",
            description: "Upload 10 Gb of files each month",
            link: URL(string: "https://help.raindrop.io/limitations")!
        )
            .tint(.orange)
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
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.headline)
                        
                        Text(description)
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SafariLink(destination: link) {
                        Text(Image(systemName: "arrow.up.forward"))
                            .imageScale(.small)
                            .fontWeight(.semibold)
                    }
                        .foregroundStyle(.tertiary)
                }
                    .padding(.vertical, 8)
            } icon: {
                Image(systemName: systemImage)
                    .font(.title)
                    .symbolVariant(.fill)
                    .foregroundStyle(.tint)
            }
        }
    }
}
