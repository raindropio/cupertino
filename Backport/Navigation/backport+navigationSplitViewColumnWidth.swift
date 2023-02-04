import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func navigationSplitViewColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View {
        if #available(iOS 16, *) {
            content.navigationSplitViewColumnWidth(min: min, ideal: ideal, max: max)
        } else {
            content.overlay(NSVCW(min: min, ideal: ideal, max: max).opacity(0))
        }
    }
}

fileprivate struct NSVCW: UIViewControllerRepresentable {
    var min: CGFloat?
    var ideal: CGFloat
    var max: CGFloat? = nil
    
    func makeUIViewController(context: Context) -> VC {
        .init(self)
    }

    func updateUIViewController(_ controller: VC, context: Context) {
        controller.update(self)
    }
}

extension NSVCW {
    class VC: UIViewController {
        var base: NSVCW
        
        init(_ base: NSVCW) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        func update(_ base: NSVCW) {
            self.base = base
            
            //find uikit
            var splitView: UISplitViewController?
            var controller: UIViewController?
            
            var current: UIViewController = self
            while let parent = current.parent {
                if let s = parent as? UISplitViewController {
                    controller = current
                    splitView = s
                    break
                }
                current = parent
            }
            
            guard let splitView, let controller else { return }
            
            let index = splitView.viewControllers.firstIndex(of: controller)
            guard let index else { return }
            
            switch index {
            //primary column
            case 0:
                splitView.preferredPrimaryColumnWidth = base.ideal
                if let min = base.min {
                    splitView.minimumPrimaryColumnWidth = min
                }
                if let max = base.max {
                    splitView.maximumPrimaryColumnWidth = max
                }
                
            //supplementary
            case 2:
                splitView.preferredSupplementaryColumnWidth = base.ideal
                if let min = base.min {
                    splitView.minimumSupplementaryColumnWidth = min
                }
                if let max = base.max {
                    splitView.maximumSupplementaryColumnWidth = max
                }
                
            default: break
            }
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(base)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
