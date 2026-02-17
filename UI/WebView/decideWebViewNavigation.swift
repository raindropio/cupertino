import SwiftUI
import WebKit

struct WebViewNavigationDecisionKey: EnvironmentKey {
    static let defaultValue: ((WKNavigationAction, Bool) -> WKNavigationActionPolicy)? = nil
}

extension EnvironmentValues {
    var webViewNavigationDecision: ((WKNavigationAction, Bool) -> WKNavigationActionPolicy)? {
        get { self[WebViewNavigationDecisionKey.self] }
        set { self[WebViewNavigationDecisionKey.self] = newValue }
    }
}

public extension View {
    func decideWebViewNavigation(
        decide: @escaping (_ navigationAction: WKNavigationAction, _ opensInNewWindow: Bool) -> WKNavigationActionPolicy
    ) -> some View {
        environment(\.webViewNavigationDecision, decide)
    }
}
