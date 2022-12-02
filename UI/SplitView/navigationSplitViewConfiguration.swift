import SwiftUI

public extension View {
    func navigationSplitViewConfiguration(sidebarMin: Double? = nil) -> some View {
        overlay {
            NavigationSplitViewFixes(sidebarMin: sidebarMin)
                .opacity(0)
        }
    }
}

fileprivate struct NavigationSplitViewFixes: UIViewControllerRepresentable {
    var sidebarMin: Double?
    
    func makeUIViewController(context: Context) -> VC {
        .init(self)
    }

    func updateUIViewController(_ controller: VC, context: Context) {
        controller.update(self)
    }
}

extension NavigationSplitViewFixes {
    class VC: UIViewController {
        var base: NavigationSplitViewFixes
        
        init(_ base: NavigationSplitViewFixes) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        func update(_ base: NavigationSplitViewFixes) {
            self.base = base
            
            if let svc = parent?.children.first as? UISplitViewController {
                if let sidebarMin = base.sidebarMin {
                    svc.minimumPrimaryColumnWidth = sidebarMin
                }
                svc.maximumPrimaryColumnWidth = .infinity
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
