import SwiftUI
import API
import UI

extension Browser {
    struct Title {
        @EnvironmentObject private var app: AppRouter
        @ObservedObject var page: WebPage
        @Binding var raindrop: Raindrop
    }
}

extension Browser.Title {
    private var mode: Browse.Location.Mode {
        page.request?.attribute as? Browse.Location.Mode ?? .raw
    }
    
    private var title: String {
        switch mode {
        case .cache: return "Permanent copy"
        case .preview: return "Preview"
        default: return page.url?.host ?? ""
        }
    }
}

extension Browser.Title: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleMenu {
            Picker("", selection: .init { mode } set: {
                if raindrop.isNew {
                    app.navigate(url: raindrop.link)
                } else {
                    app.navigate(raindrop: raindrop.id, mode: $0)
                }
            }) {
                if !raindrop.isNew {
                    Label("Preview", systemImage: "eyeglasses")
                        .tag(Browse.Location.Mode.preview)
                    
                    if raindrop.file == nil {
                        Label("Permanent copy", systemImage: "clock.arrow.circlepath")
                            .tag(Browse.Location.Mode.cache)
                    }
                }
                
                Label("Original page", systemImage: "safari")
                    .tag(Browse.Location.Mode.raw)
            }
            
            if let url = page.url {
                Link(destination: url) {
                    Label("Open in browser", systemImage: "arrow.up.forward")
                }
            }
        }
    }
}
