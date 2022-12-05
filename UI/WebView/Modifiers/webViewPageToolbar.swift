import SwiftUI
import Backport

public extension View {
    func webViewPageToolbar(_ page: WebPage) -> some View {
        modifier(WebViewPageToolbar(page: page))
    }
    
    func webViewPageToolbar(_ page: WebPage, overrideURL: URL?) -> some View {
        modifier(WebViewPageToolbar(page: page, overrideURL: overrideURL))
    }
}

struct WebViewPageToolbar: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @ObservedObject var page: WebPage
    var overrideURL: URL?
    
    private var portrait: Bool {
        verticalSizeClass == .regular && horizontalSizeClass == .compact
    }
            
    private var toolbarItemPlacement: ToolbarItemPlacement {
        portrait ? .bottomBar : .automatic
    }
    
    var currentURL: URL {
        overrideURL ?? page.url ?? .init(string: "about:blank")!
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: toolbarItemPlacement) {
                    Button(action: page.goBack) {
                        Image(systemName: "chevron.left")
                    }
                        .disabled(!page.canGoBack)
                    
                    Spacer()
                }
                
                ToolbarItemGroup(placement: toolbarItemPlacement) {
                    Button(action: page.goForward) {
                        Image(systemName: "chevron.right")
                    }
                        .disabled(!page.canGoForward)
                    
                    Spacer()
                }
                
                ToolbarItemGroup(placement: toolbarItemPlacement) {
                    Backport.ShareLink(item: currentURL)
                        .disabled(page.url == nil)
                    
                    Spacer()
                }
                
                ToolbarItem(placement: toolbarItemPlacement) {
                    Link(destination: currentURL) {
                        Image(systemName: "safari")
                    }
                        .disabled(page.url == nil)
                }
            }
    }
}
