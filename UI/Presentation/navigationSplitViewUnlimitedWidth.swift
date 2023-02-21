import SwiftUI

public extension View {
    func navigationSplitViewUnlimitedWidth() -> some View {
        overlay(NSVUW().opacity(0))
    }
}

fileprivate struct NSVUW: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VC { .init() }
    func updateUIViewController(_ controller: VC, context: Context) {}
}

extension NSVUW {
    class VC: UIViewController {
        func fix() {
            guard
                let some = parent?.children.first(where: { $0 is UISplitViewController }),
                let svc = some as? UISplitViewController
            else { return }
            
            svc.minimumPrimaryColumnWidth = 0
            svc.maximumPrimaryColumnWidth = .infinity
            
            if svc.style == .tripleColumn {
                svc.minimumSupplementaryColumnWidth = 0
                svc.maximumSupplementaryColumnWidth = .infinity
            }
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            fix()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            fix()
        }
    }
}
