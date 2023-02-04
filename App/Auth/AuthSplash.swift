import SwiftUI

struct AuthSplash: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TabView {
            Slide(
                title: "Save Webpages, Files & Highlights",
                colors: [.blue, .indigo]
            ) {
                Image(systemName: "star.square")
            } description: {
                Text("Even if a page you've saved is taken down, you'll still have a ") +
                    Text(Image(systemName: "lock")) +
                    Text(" copy of it")
            }
            
            Slide(
                title: "Organize with Collections, Filters & Tags",
                colors: [.pink, .orange]
            ) {
                Image(systemName: "folder")
            } description: {
                Text("Group related items within the same context. Remove duplicate & broken links.")
            }
            
            Slide(
                title: "Search by Page Content",
                colors: [.blue, .green]
            ) {
                Image(systemName: "sparkle.magnifyingglass")
            } description: {
                Text("Search through the entire content of a pages and PDF’s you’ve saved.")
            }
            
            Slide(
                title: "Import & Sync Favorites",
                colors: [.pink, .indigo]
            ) {
                Image(systemName: "square.and.arrow.down")
            } description: {
                Text("Transfer existing bookmarks and automatically save favorite YouTube videos or send items to your Google Sheets")
            }
            
            Slide(
                title: "Web & Desktop App",
                colors: [.green, .teal]
            ) {
                Image(systemName: "laptopcomputer.and.iphone")
            } description: {
                Text("Access your bookmarks seamlessly across all your devices\n\n")
            }
        }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: colorScheme == .light ? .always : .never))
    }
}
