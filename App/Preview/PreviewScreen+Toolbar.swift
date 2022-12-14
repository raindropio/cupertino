import SwiftUI
import API
import UI
import Backport
import Common

extension PreviewScreen {
    struct Toolbar {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        @Environment(\.verticalSizeClass) private var verticalSizeClass
        
        @ObservedObject var page: WebPage
        var raindrop: Raindrop?
        @Binding var showHighlights: Bool
    }
}

extension PreviewScreen.Toolbar {
    private var portrait: Bool {
        verticalSizeClass == .regular && horizontalSizeClass == .compact
    }
            
    private var toolbarItemPlacement: ToolbarItemPlacement {
        portrait ? .bottomBar : .automatic
    }
    
    private var url: URL? {
        (page.canGoBack ? page.url : nil) ?? raindrop?.link
    }
}

extension PreviewScreen.Toolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .backport.toolbarRole(.editor)
        .backport.toolbar(page.prefersHiddenToolbars && !showHighlights ? .hidden : .automatic, for: .navigationBar, .tabBar, .bottomBar)
        .animation(.default, value: page.prefersHiddenToolbars)
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
                Toggle(isOn: $showHighlights) {
                    Image(systemName: Filter.Kind.highlights.systemImage)
                }
                    .toggleStyle(.button)
                
                Spacer()
            }
            
            ToolbarItemGroup(placement: toolbarItemPlacement) {
                if let url {
                    Backport.ShareLink(item: url)
                    
                    Spacer()
                }
            }
            
            ToolbarItem(placement: toolbarItemPlacement) {
                if let url {
                    Link(destination: url) {
                        Image(systemName: "safari")
                    }
                }
            }
        }
    }
}
