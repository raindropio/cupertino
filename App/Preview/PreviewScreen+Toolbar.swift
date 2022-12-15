import SwiftUI
import API
import UI
import Backport
import Common

extension PreviewScreen {
    struct Toolbar {
        @EnvironmentObject private var page: WebPage
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        @Environment(\.verticalSizeClass) private var verticalSizeClass
        
        @Binding var highlightsList: Bool
    }
}

extension PreviewScreen.Toolbar {
    private var portrait: Bool {
        verticalSizeClass == .regular && horizontalSizeClass == .compact
    }
            
    private var toolbarItemPlacement: ToolbarItemPlacement {
        portrait ? .bottomBar : .automatic
    }
}

extension PreviewScreen.Toolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .backport.toolbarRole(.editor)
        .backport.toolbar(page.prefersHiddenToolbars && !highlightsList ? .hidden : .automatic, for: .navigationBar, .tabBar, .bottomBar)
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
                Toggle(isOn: $highlightsList) {
                    Image(systemName: Filter.Kind.highlights.systemImage)
                }
                    .toggleStyle(.button)
                
                Spacer()
            }
            
            ToolbarItemGroup(placement: toolbarItemPlacement) {
                if let url = page.url {
                    Backport.ShareLink(item: url)
                    
                    Spacer()
                }
            }
            
            ToolbarItem(placement: toolbarItemPlacement) {
                if let url = page.url {
                    Link(destination: url) {
                        Image(systemName: "safari")
                    }
                }
            }
        }
    }
}
