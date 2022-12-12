import SwiftUI
import API
import UI

extension PreviewScreen {
    struct Title {
        @EnvironmentObject private var app: AppRouter
        @State private var showOptions = false

        @ObservedObject var page: WebPage
        var mode: Mode
        var raindrop: Raindrop?
    }
}

extension PreviewScreen.Title {
    private var title: String {
        if page.canGoBack {
            return page.url?.host ?? ""
        }
        
        switch mode {
        case .article: return "Reader"
        case .cache: return "Permanent copy"
        default: return raindrop?.link.host ?? ""
        }
    }
}

extension PreviewScreen.Title: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .backport.toolbarTitleMenu {
            if !page.canGoBack {
                if mode == .article {
                    Button {
                        showOptions = true
                    } label: {
                        Label("Font & style", systemImage: "textformat.alt")
                    }
                    
                    Divider()
                } else if raindrop?.type == .link {
                    Button {
                        app.replace(.preview(raindrop!.id, .article))
                    } label: {
                        Label("Show Reader", systemImage: "eyeglasses")
                    }
                }
                
                if mode != .cache, raindrop?.file == nil {
                    Button {
                        app.replace(.preview(raindrop!.id, .cache))
                    } label: {
                        Label("Show permanent copy", systemImage: "clock.arrow.circlepath")
                    }
                }
                
                if mode != .raw {
                    Button {
                        app.replace(.preview(raindrop!.id, .raw))
                    } label: {
                        Label("Show original", systemImage: "safari")
                    }
                }
            }
        }
        .sheet(isPresented: $showOptions, content: Reader.init)
    }
}
