import SwiftUI
import API
import UI

struct SettingsWebApp: View {
    @StateObject private var page = WebPage()
    var subpage: Subpage
    
    var body: some View {
        WebView(
            page,
            request: .init(
                URL(string: "https://app.raindrop.io/settings/\(subpage)")!,
                caching: .reloadRevalidatingCacheData
            ),
            userAgent: "RaindropMobile"
        )
//            .navigationTitle(page.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension SettingsWebApp {
    enum Subpage: String {
        case account
        case backups
        case `import`
    }
}
