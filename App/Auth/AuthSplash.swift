import SwiftUI
import UI

struct AuthSplash: View {
    var body: some View {
        Carousel {
            Slide(
                title: "Save Web Pages, Books & Highlights",
                colors: [.blue, .indigo]
            ) {
                Image(systemName: "checkmark.icloud")
            } description: {
                Text("Keep your favorite things in one place")
            }
            
            Slide(
                title: "Organize with Collections & Tags",
                colors: [.pink, .orange]
            ) {
                Image(systemName: "tray.full")
            } description: {
                Text("Group related items within the same context. Remove duplicate & broken links")
            }

            Slide(
                title: "Build Your Knowledge Base",
                colors: [.red, .pink]
            ) {
                Image(systemName: "sparkles")
            } description: {
                Text("Ask questions, get summaries, and organize — all powered by AI")
            }

            Slide(
                title: "Never Forget a Thing",
                colors: [.pink, .indigo]
            ) {
                Image(systemName: "bell")
            } description: {
                Text("Saved something for later? Reminders resurface your bookmarks at the right time")
            }

            Slide(
                title: "Access from Any Device",
                colors: [.green, .teal]
            ) {
                Image(systemName: "laptopcomputer.and.iphone")
            } description: {
                Text("Access your items seamlessly across all your devices\n\n")
            }
        }
    }
}
