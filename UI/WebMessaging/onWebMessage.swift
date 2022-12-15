import SwiftUI
import WebKit

public extension View {
    func onWebMessage<M: Decodable>(_ page: WebPage, channel: String, receive: @escaping (M) async -> Void) -> some View {
        modifier(OnWebMessageModifier(page: page, channel: channel, receive: receive))
    }
}

fileprivate struct OnWebMessageModifier<M: Decodable> {
    @StateObject private var handler = Handler()
    
    @ObservedObject var page: WebPage
    var channel: String
    var receive: (M) async -> Void
}

extension OnWebMessageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear { handler.connect(page, channel, receive) }
            .onDisappear { handler.disconnect(page, channel) }
    }
}

extension OnWebMessageModifier {
    class Handler: NSObject, ObservableObject, WKScriptMessageHandler {
        private let decoder = JSONDecoder()
        
        var receive: ((M) async -> Void)?
        
        func connect(_ page: WebPage, _ channel: String, _ receive: @escaping (M) async -> Void) {
            self.receive = receive
            page.view?.configuration.userContentController.add(self, name: channel)
        }
        
        func disconnect(_ page: WebPage, _ channel: String) {
            self.receive = nil
            page.view?.configuration.userContentController.removeScriptMessageHandler(forName: channel)
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let receive else { return }
            guard let data = try? JSONSerialization.data(withJSONObject: message.body) else { return }
            guard let message = try? decoder.decode(M.self, from: data) else { return }
            //TODO: somehow iterate through
            Task {
                await receive(message)
            }
        }
    }
}
