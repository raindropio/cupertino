import SwiftUI
import API
import UI

extension PreviewScreen {
    struct Toolbar: ViewModifier {
        @ObservedObject var page: WebPage
        @Binding var mode: Mode
        var raindrop: Raindrop
        
        @State private var showOptions = false

        func body(content: Content) -> some View {
            content
                .backport.toolbar(page.prefersHiddenToolbars ? .hidden : .automatic, for: .navigationBar, .tabBar, .bottomBar)
                .animation(.default, value: page.prefersHiddenToolbars)
                .backport.toolbarTitleMenu {
                    if !page.canGoBack {
                        if mode == .article {
                            Button {
                                showOptions = true
                            } label: {
                                Label("Font & style", systemImage: "textformat.alt")
                            }
                            
                            Divider()
                        } else if raindrop.type == .link {
                            Button {
                                mode = .article
                            } label: {
                                Label("Show Reader", systemImage: "eyeglasses")
                            }
                        }
                        
                        if mode != .cache, raindrop.file == nil {
                            Button {
                                mode = .cache
                            } label: {
                                Label("Show permanent copy", systemImage: "clock.arrow.circlepath")
                            }
                        }
                        
                        if mode != .raw {
                            Button {
                                mode = .raw
                            } label: {
                                Label("Show original", systemImage: "safari")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showOptions, content: Options.init)
        }
    }
}
