import SwiftUI
import API
import UI

extension PreviewScreen {
    struct Title {
        @EnvironmentObject private var page: WebPage
        @EnvironmentObject private var app: AppRouter
    }
}

extension PreviewScreen.Title {
    private var mode: PreviewScreen.Mode {
        page.request?.attribute as? PreviewScreen.Mode ?? .raw
    }
    
    private var title: String {
        switch mode {
        case .article: return "Reader"
        case .cache: return "Permanent copy"
        case .embed: return "Preview"
        default: break
        }
        
        return page.url?.host ?? ""
    }
}

extension PreviewScreen.Title: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .backport.toolbarTitleMenu {
            Picker(
                "",
                selection: .init {
                    mode
                } set: { _ in
                    if let url = page.url {
                        //app.replace(.preview(url, $0))
                    }
                }
            ) {
                Label("Reader", systemImage: "eyeglasses")
                    .tag(PreviewScreen.Mode.article)
                Label("Permanent copy", systemImage: "clock.arrow.circlepath")
                    .tag(PreviewScreen.Mode.cache)
                Label("Original page", systemImage: "safari")
                    .tag(PreviewScreen.Mode.raw)
            }
        }
    }
}
