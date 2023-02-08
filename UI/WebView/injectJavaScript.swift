import SwiftUI
import WebKit

public extension View {
    func injectJavaScript(@ObservedObject _ page: WebPage, file: URL) -> some View {
        modifier(Injector(page: page, file: file))
    }
}

fileprivate struct Injector: ViewModifier {
    @ObservedObject var page: WebPage
    var file: URL
    
    func attach() {
        guard
            let view = page.view,
            let source = try? String(contentsOf: file),
            !view.configuration.userContentController.userScripts.contains(where: {
                $0.source == source
            })
        else { return }
        
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        view.configuration.userContentController.addUserScript(script)
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: attach)
            .task(id: page.view) { attach() }
    }
}
