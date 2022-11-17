import WebKit

extension RDWebView: WKNavigationDelegate {
    //start loading
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let webView = webView as? RDWebView {
            webView.error = nil
        }
    }
    
    //getting data
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.isOpaque = true
    }
    
    //end loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let webView = webView as? RDWebView {
            webView.error = nil
        }
    }
    
    //error loading
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let webView = webView as? RDWebView {
            if (error as NSError).code != NSURLErrorCancelled {
                webView.error = error
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if let webView = webView as? RDWebView {
            if (error as NSError).code != NSURLErrorCancelled {
                webView.error = error
            }
        }
    }
}
