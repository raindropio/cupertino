import SwiftUI

struct AuthSplash: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TabView {
            Slide(
                title: "Save Web Pages, Books & Highlights",
                colors: [.blue, .indigo]
            ) {
                Image(systemName: "star.square")
            } description: {
                Text("Keep your favorite things in one place")
            }
            
            Slide(
                title: "Organize with Collections & Tags",
                colors: [.pink, .orange]
            ) {
                Image(systemName: "tray.full")
            } description: {
                Text("Group related items within the same context. Remove duplicate & broken links.")
            }
            
            Slide(
                title: "Search by Content",
                colors: [.blue, .green]
            ) {
                Image(systemName: "sparkle.magnifyingglass")
            } description: {
                Text("Search through the entire content of a pages you’ve saved.")
            }
            
            Slide(
                title: "Import & Sync Favorites",
                colors: [.pink, .indigo]
            ) {
                Image(systemName: "square.and.arrow.down")
            } description: {
                Text("Transfer existing bookmarks & automatically sync favorites from 1000+ websites")
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
