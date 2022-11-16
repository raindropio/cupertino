import SwiftUI
import API
import UI

struct CustomBrowser: View {
    @StateObject private var page = WebPage()
    var raindrop: Raindrop
    
    var body: some View {
        WebView(page, url: raindrop.link)
            .navigationBarTitleDisplayMode(.inline)
    }
}
