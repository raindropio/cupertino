import SwiftUI
import API
import UI

extension PreviewScreen {
    struct Title {
        @EnvironmentObject private var page: WebPage
        @EnvironmentObject private var app: AppRouter
        @State private var showOptions = false

        var mode: Mode
    }
}

extension PreviewScreen.Title {
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
            if let url = page.url {
                if mode != .article && mode != .embed {
                    Button {
                        app.replace(.preview(url, .article))
                    } label: {
                        Label("Show reader", systemImage: "eyeglasses")
                    }
                }
                
                if mode != .cache {
                    Button {
                        app.replace(.preview(url, .cache))
                    } label: {
                        Label("Show permanent copy", systemImage: "clock.arrow.circlepath")
                    }
                }
                
                if mode != .raw {
                    Button {
                        app.replace(.preview(url, .raw))
                    } label: {
                        Label("Show original", systemImage: "safari")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                if mode == .article {
                    Button {
                        showOptions = true
                    } label: {
                        Label("Font & style", systemImage: "textformat.size")
                    }
                        .popover(isPresented: $showOptions, content: Reader.init)
                }
            }
        }
    }
}
