import WebKit

extension WebPage: WKNavigationDelegate {
    //start
    @MainActor public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.error = nil
        changed()
    }
    
    //content painting
    @MainActor public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        changed()
    }
    
    //redirect
    @MainActor public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        changed()
    }
    
    //finish
    @MainActor public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        changed()
    }
    
    //error
    @MainActor public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.error = error
        changed()
    }
    
    @MainActor public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard (error as NSError).code != NSURLErrorCancelled else { return }
        self.webView(webView, didFail: navigation, withError: error)
    }
}
