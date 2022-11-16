import SwiftUI
import API
import UI

struct OpenScreen: View {
    @AppStorage(PreferredBrowser.storageKey) private var browser = PreferredBrowser.custom
    var raindrop: Raindrop
    
    var body: some View {
        switch browser {
        case .custom:
            CustomBrowser(raindrop: raindrop)
        case .safari:
            SafariView(url: raindrop.link)
        case .external:
            ExternalBrowser(raindrop: raindrop)
        }
    }
}
