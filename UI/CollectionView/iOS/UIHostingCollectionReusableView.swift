#if os(iOS)
import SwiftUI
import Foundation

class UIHostingCollectionReusableView: UICollectionReusableView {
    private var controller: UIHostingController<AnyView>?
    
    func host(_ view: AnyView, _ parent: UIViewController? = nil) {
        if controller != nil {
            controller?.rootView = view
        } else {
            controller = UIHostingController(rootView: view)
            if let hostView = controller?.view {
                hostView.backgroundColor = nil
                hostView.insetsLayoutMarginsFromSafeArea = false
                parent?.addChild(controller!)
                addSubview(hostView)
                hostView.frame = bounds
                
                if let parent {
                    controller?.didMove(toParent: parent)
                }
            }
        }
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
