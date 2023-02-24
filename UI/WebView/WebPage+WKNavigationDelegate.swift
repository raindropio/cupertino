import WebKit

extension WebPage: WKNavigationDelegate {
    //start
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.error = nil
    }
    
    //response recieved
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        if navigationResponse.isForMainFrame {
            //remove background for non text response
            let isText = navigationResponse.response.mimeType?.contains("text") ?? true
            view?.isOpaque = isText
            view?.backgroundColor = isText ? nil : .clear
            
            //show error for non ok response
            if let response = navigationResponse.response as? HTTPURLResponse {
                if response.statusCode >= 400 {
                    self.error = NSError(
                        domain: HTTPURLResponse.localizedString(forStatusCode: response.statusCode),
                        code: response.statusCode
                    )
                }
            }
        }
        
        decisionHandler(.allow)
    }
    
    //finish
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.refreshControl?.endRefreshing()
        
        //fix inset issue on some websites
        webView.scrollView.contentInset.top = 1
        webView.scrollView.contentInset.top = 0
    }
    
    //error
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard (error as NSError).code != NSURLErrorCancelled else { return }
        self.error = error
        webView.scrollView.refreshControl?.endRefreshing()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webView(webView, didFail: navigation, withError: error)
    }
}
