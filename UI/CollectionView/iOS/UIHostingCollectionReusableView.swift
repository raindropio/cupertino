import SwiftUI
import Foundation

class UIHostingCollectionReusableView<RootView: View>: UICollectionReusableView {
    private var hostController: UIHostingController<RootView>?
    
    override func prepareForReuse() {
        if let hostView = hostController?.view {
            hostView.removeFromSuperview()
        }
        hostController = nil
    }
    
    var rootView: RootView? {
        willSet {
            guard let view = newValue else { return }
            hostController = UIHostingController(rootView: view)
            if let hostView = hostController?.view {
                hostView.frame = self.bounds
                hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                hostView.backgroundColor = nil
                addSubview(hostView)
            }
        }
    }
}
