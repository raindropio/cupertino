import SwiftUI

public extension View {
    func navigationSplitViewUnlockSize() -> some View {
        #if canImport(UIKit)
        modifier(NSVUS())
        #else
        self
        #endif
    }
}

fileprivate struct NSVUS: ViewModifier {
    func body(content: Content) -> some View {
        if isPhone {
            content
        } else {
            content
                .overlay(NSVUW().opacity(0))
        }
    }
}

#if canImport(UIKit)
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
            svc.maximumPrimaryColumnWidth = view.frame.width / 2
            if svc.maximumPrimaryColumnWidth < 400 {
                svc.maximumPrimaryColumnWidth = view.frame.width * 0.9
            }
                        
            if svc.style == .tripleColumn {
                svc.minimumSupplementaryColumnWidth = 0
                svc.maximumSupplementaryColumnWidth = view.frame.width / 2
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
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            fix()
        }
    }
}
#endif
