import SwiftUI

public extension View {
    func webViewPageToolbar(_ page: WebPage) -> some View {
        modifier(WebViewPageToolbar(page: page))
    }
}

struct WebViewPageToolbar: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @ObservedObject var page: WebPage
    
    private var portrait: Bool {
        verticalSizeClass == .regular && horizontalSizeClass == .compact
    }
            
    private var toolbarItemPlacement: ToolbarItemPlacement {
        portrait ? .bottomBar : .automatic
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
                    ShareLink(item: page.url ?? .init(string: "about:blank")!)
                        .disabled(page.url == nil)
                    
                    Spacer()
                }
                
                ToolbarItem(placement: toolbarItemPlacement) {
                    Link(destination: page.url ?? .init(string: "about:blank")!) {
                        Image(systemName: "safari")
                    }
                        .disabled(page.url == nil)
                }
            }
    }
}
