import SwiftUI
import API
import UI

extension PreviewScreen {
    struct Title: ViewModifier {
        @ObservedObject var page: WebPage
        var mode: Mode
        var raindrop: Raindrop
        
        var title: String {
            if page.canGoBack {
                return page.title ?? page.current?.host ?? ""
            } else {
                switch mode {
                case .article: return "Reader"
                case .cache: return "Permanent copy"
                default: return raindrop.title
                }
            }
        }
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
