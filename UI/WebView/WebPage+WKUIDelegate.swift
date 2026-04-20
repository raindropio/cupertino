import WebKit

extension WebPage: WKUIDelegate {
    //deny camera/microphone — prevents TCC crash on missing NSMicrophoneUsageDescription
    public func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.deny)
    }

    //window.open, etc
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let handler = navigationDecisionHandler {
            if case .allow = handler(navigationAction, true), navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
        } else {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
        }
        return nil
    }
    
    //alert
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        self.alert = .init(
            title: frame.request.url?.host,
            message: message,
            callback: completionHandler
        )
    }
    
    //confirm
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        self.confirm = .init(
            title: frame.request.url?.host,
            message: message,
            callback: completionHandler
        )
    }
    
    //prompt
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        self.prompt = .init(
            title: frame.request.url?.host,
            message: prompt,
            defaultValue: defaultText,
            callback: completionHandler
        )
    }
}
