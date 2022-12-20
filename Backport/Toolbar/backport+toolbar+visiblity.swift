import SwiftUI

extension Backport where Wrapped: View {
    struct ToolbarVisibility: UIViewControllerRepresentable {
        var visibility: SwiftUI.Visibility
        var bars: [Backport.ToolbarPlacement]
        
        func makeUIViewController(context: Context) -> VC {
            .init(self)
        }
        
        func updateUIViewController(_ controller: VC, context: Context) {
            controller.update(self, animated: context.transaction.animation != nil)
        }
    }
}

extension Backport.ToolbarVisibility {
    class VC: UIViewController {
        var base: Backport.ToolbarVisibility
        
        init(_ base: Backport.ToolbarVisibility) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        func update(_ base: Backport.ToolbarVisibility, animated: Bool = false) {
            self.base = base
            
            let isNavigationBarHidden: Bool? = base.visibility == .hidden && (base.bars.contains(.navigationBar) || base.bars.contains(.automatic))
            if parent?.navigationController?.isNavigationBarHidden != isNavigationBarHidden {
                parent?.navigationController?.setNavigationBarHidden(isNavigationBarHidden!, animated: animated)
            }
            
            let isToolbarHidden: Bool? = base.visibility == .hidden && (base.bars.contains(.navigationBar) || base.bars.contains(.automatic))
            if parent?.navigationController?.isToolbarHidden != isToolbarHidden {
                parent?.navigationController?.setToolbarHidden(isNavigationBarHidden!, animated: animated)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(base)
        }
    }
}
