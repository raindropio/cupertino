#if os(iOS)
import SwiftUI
import Foundation

class UIHostingCollectionReusableView: UICollectionReusableView {
    private var controller: UIHostingController<AnyView>?
    
//    override func prepareForReuse() {
//        if let hostView = controller?.view {
//            hostView.removeFromSuperview()
//        }
//        controller = nil
//    }
    
    var rootView: AnyView? {
        willSet {
            guard let view = newValue else { return }
            
            if controller != nil {
                controller?.sizingOptions = .preferredContentSize
                controller?.rootView = view
            } else {
                controller = UIHostingController(rootView: view)
                if let hostView = controller?.view {
                    hostView.backgroundColor = nil
                    addSubview(hostView)
                    hostView.frame = bounds
                }
            }
        }
    }
    
    override public var safeAreaInsets: UIEdgeInsets {
        .zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        controller?.view.frame = bounds
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        controller?.view.setNeedsLayout()
        controller?.view.layoutIfNeeded()
        
        return controller?.sizeThatFits(
            in: targetSize
        ) ?? targetSize
    }
}
#endif
