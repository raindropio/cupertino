import SwiftUI
import UI

struct FreeFeatures: View {
    var body: some View {
        Group {
            Label("Unlimited items", systemImage: "checkmark")
            Label("Unlimited collections", systemImage: "checkmark")
            Label("Unlimited highlights", systemImage: "checkmark")
            Label("Unlimited devices", systemImage: "checkmark")
            
            WithLink(url: URL(string: "https://help.raindrop.io/automation")!) {
                Label("More than 2,600 integrations", systemImage: "puzzlepiece.extension")
            }
            
            WithLink(url: URL(string: "https://raindrop.io/download")!) {
                Label("Apps for macOS, iOS & Safari", systemImage: "laptopcomputer.and.iphone")
            }
            
            WithLink(url: URL(string: "https://help.raindrop.io/collaboration")!) {
                Label("Collaboration", systemImage: "person.2")
            }
            
            WithLink(url: URL(string: "https://help.raindrop.io/public-page")!) {
                Label("Public page", systemImage: "globe")
            }
            
            WithLink(url: URL(string: "https://raindrop.io")!) {
                Label("All essential features", systemImage: "checklist.checked")
            }
        }
            .listItemTint(.monochrome)
            .symbolVariant(.fill)
    }
}

extension FreeFeatures {
    struct WithLink<L: View>: View {
        var url: URL
        var label: () -> L
        
        var body: some View {
            HStack {
                label()
                Spacer()
                SafariLink(destination: url) {
                    Image(systemName: "arrow.up.forward")
                        .imageScale(.small)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
