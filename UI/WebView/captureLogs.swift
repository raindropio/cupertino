import SwiftUI
import WebKit

public extension View {
    func captureLogs(@ObservedObject _ page: WebPage) -> some View {
        modifier(Injector(page: page))
    }
}

fileprivate let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"

class LoggingMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}

fileprivate struct Injector: ViewModifier {
    @ObservedObject var page: WebPage
    
    func attach() {
        guard
            let view = page.view,
            !view.configuration.userContentController.userScripts.contains(where: {
                $0.source == source
            })
        else { return }
        
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        view.configuration.userContentController.addUserScript(script)
        view.configuration.userContentController.add(LoggingMessageHandler(), name: "logHandler")
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: attach)
            .task(id: page.view) { attach() }
    }
}
