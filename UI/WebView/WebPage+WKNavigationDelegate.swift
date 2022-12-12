import WebKit

extension WebPage: WKNavigationDelegate {
    //start
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.error = nil
    }
    
    //finish
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.refreshControl?.endRefreshing()
    }
    
    //error
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.error = error
        webView.scrollView.refreshControl?.endRefreshing()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard (error as NSError).code != NSURLErrorCancelled else { return }
        self.webView(webView, didFail: navigation, withError: error)
    }
}
