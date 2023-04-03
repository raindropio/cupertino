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
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}

extension SettingsWebApp {
    enum Subpage: String, Identifiable {
        case account
        case backups
        case `import`
        case tfa
        
        var id: Self { self }
    }
}
