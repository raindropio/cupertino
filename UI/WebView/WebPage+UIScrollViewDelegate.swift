#if canImport(UIKit)
import UIKit

extension WebPage: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if prefersHiddenToolbars == true, scrollView.contentOffset.y <= 0 {
            prefersHiddenToolbars = false
        }
    }
    
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let oldY = scrollView.contentOffset.y
        let newY = targetContentOffset.pointee.y
        
        if newY == oldY {
        } else if newY > oldY, newY > scrollView.frame.height / 2 {
            if !prefersHiddenToolbars {
                prefersHiddenToolbars = true
            }
        } else {
            if prefersHiddenToolbars {
                prefersHiddenToolbars = false
            }
        }
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        prefersHiddenToolbars = false
        return true
    }
}
#endif
