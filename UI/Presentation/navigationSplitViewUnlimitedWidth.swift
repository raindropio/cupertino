import SwiftUI

public extension View {
    func navigationSplitViewUnlimitedWidth() -> some View {
        overlay(NSVUW().opacity(0))
    }
}

fileprivate struct NSVUW: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VC {
        .init()
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
}

extension NSVUW {
    class VC: UIViewController {
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            
            if let svc = parent?.children.first as? UISplitViewController {
                svc.minimumPrimaryColumnWidth = 0
                svc.maximumPrimaryColumnWidth = .infinity
                
                if svc.style == .tripleColumn {
                    svc.minimumSupplementaryColumnWidth = 0
                    svc.maximumSupplementaryColumnWidth = .infinity
                }
            }
        }
    }
}
