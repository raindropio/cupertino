import SwiftUI
import API
import UI

struct PreviewScreen: View {
    @StateObject private var page = WebPage()
    var raindrop: Raindrop
    
    var body: some View {
        WebView(page, url: raindrop.link)
            .navigationTitle(page.url?.host() ?? "Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.browser)
            .webViewHidesBarsOnSwipe(page)
            .webViewPageToolbar(page)
            .webViewProgressBar(page)
            .webViewError(page)
            .webViewAdaptColorScheme(page)
    }
}
