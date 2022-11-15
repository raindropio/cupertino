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
        
    }
    
    //end loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let webView = webView as? RDWebView {
            webView.error = nil
            
            #if canImport(UIKit)
            webView.scrollView.refreshControl?.endRefreshing()
            
            if webView.scrollView.contentOffset.y <= 0 && webView.prefersHiddenToolbars {
                webView.prefersHiddenToolbars = false
            }
            #endif
        }
    }
    
    //error loading
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let webView = webView as? RDWebView {
            webView.error = error
            
            #if canImport(UIKit)
            webView.scrollView.refreshControl?.endRefreshing()
            
            if webView.scrollView.contentOffset.y <= 0 && webView.prefersHiddenToolbars {
                webView.prefersHiddenToolbars = false
            }
            #endif
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if let webView = webView as? RDWebView {
            webView.error = error
            
            #if canImport(UIKit)
            webView.scrollView.refreshControl?.endRefreshing()
            #endif
        }
    }
}
