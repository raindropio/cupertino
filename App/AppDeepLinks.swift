import SwiftUI
import Features
import API

struct AppDeepLinks: ViewModifier {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var r: RaindropsStore
    @AppStorage("browser") private var browser: PreferredBrowser = .default
    @Environment(\.openURL) private var openURL
    @State private var safari: URL?

    func body(content: Content) -> some View {
        content
            .onDeepLink {
                switch $0 {
                case .collection(let action):
                    switch action {
                    case .open(let id):
                        router.navigate(collection: id)
                    }
                    
                case .raindrop(let action):
                    switch action {
                    case .open(let id):
                        switch browser {
                        case .inapp:
                            router.navigate(raindrop: id)
                            
                        case .safari:
                            if let url = r.state.item(id)?.link {
                                safari = url
                            }
                            
                        case .system:
                            if let url = r.state.item(id)?.link {
                                openURL(url)
                            }
                        }
                        
                    case .cache(let id):
                        router.navigate(raindrop: id, mode: .cache)
                        
                    case .preview(let id):
                        router.navigate(raindrop: id)
                    }
                    
                case .find(let find):
                    router.navigate(find: find)
                }
            }
            .safariView(item: $safari, button: .init(id: "io.raindrop.ios.share", systemImage: "info.circle"))
    }
}
