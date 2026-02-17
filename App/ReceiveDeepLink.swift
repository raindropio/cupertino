import SwiftUI
import Features
import API

struct ReceiveDeepLink: ViewModifier {
    @EnvironmentObject private var r: RaindropsStore
    @AppStorage(PreferredBrowser.key) private var browser: PreferredBrowser = .default
    @AppStorage(UniversalLinks.key) private var universalLinks: UniversalLinks = .default
    @Environment(\.openURL) private var openURL
    @State private var safari: URL?
    @State private var settings: SettingsPath?
    
    @Binding var path: SplitViewPath
    
    private func openLink(find: FindBy, id: Raindrop.ID) {
        switch browser {
        case .inapp:
            path.push(.preview(find, id))
        case .safari:
            if let url = r.state.item(id)?.link {
                safari = url
            }
        case .system:
            if let url = r.state.item(id)?.link {
                openURL(url)
            }
        }
    }

    func body(content: Content) -> some View {
        content.onDeepLink {
            switch $0 {
            case .collection(let action):
                switch action {
                case .open(let id):
                    path.push(.init(id))
                }
                
            case .raindrop(let action):
                switch action {
                case .open(let find, let id):
                    if universalLinks == .enabled, let url = r.state.item(id)?.link {
                        UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { success in
                            if !success {
                                openLink(find: find, id: id)
                            }
                        }
                    } else {
                        openLink(find: find, id: id)
                    }
                    
                case .cache(let id):
                    path.push(.cached(id))
                    
                case .preview(let find, let id):
                    path.push(.preview(find, id))
                    
                case .ask(let id):
                    path.push(.preview(path.lastFind ?? .init(), id))
                    path.ask = true
                }
                
            case .find(let find):
                path.push(find)
                
            case .settings(let action):
                switch action {
                case .extensions:
                    settings = .init(screen: .extensions)
                    
                case nil:
                    #if canImport(UIKit)
                    settings = .init()
                    #else
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    #endif
                }
                
            case .ask:
                path.ask = true
            }
        }
            #if os(iOS)
            .safariView(item: $safari, button: .init(id: "io.raindrop.ios.share", systemImage: "info.circle"))
            #endif
            #if canImport(UIKit)
            .sheet(item: $settings, content: SettingsIOS.init)
            #endif
    }
}
