import SwiftUI
import SafariServices

class RDSafariViewController: SFSafariViewController {
    var stop = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if navigationController?.navigationBar.alpha != 0.0 {
            navigationController?.navigationBar.alpha = 0.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.alpha = 1
    }
}
