import SwiftUI
import Features
import API

struct ReceiveDeepLink: ViewModifier {
    @EnvironmentObject private var r: RaindropsStore
    @AppStorage("browser") private var browser: PreferredBrowser = .default
    @Environment(\.openURL) private var openURL
    @State private var safari: URL?
    @State private var settings: SettingsPath?
    
    @Binding var path: SplitViewPath

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
                    switch browser {
                    case .inapp:
                        path.push(.preview(find, id))
                        
                    #if os(iOS)
                    case .safari:
                        if let url = r.state.item(id)?.link {
                            safari = url
                        }
                    #endif
                        
                    case .system:
                        if let url = r.state.item(id)?.link {
                            openURL(url)
                        }
                    }
                    
                case .cache(let id):
                    path.push(.cached(id))
                    
                case .preview(let find, let id):
                    path.push(.preview(find, id))
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
