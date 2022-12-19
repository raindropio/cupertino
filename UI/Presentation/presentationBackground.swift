import SwiftUI

#if canImport(UIKit)
public extension View {
    func presentationBackground(_ visibility: Visibility) -> some View {
        overlay {
            PresentationTransparentBackground()
                .opacity(0)
        }
    }
}

fileprivate struct PresentationTransparentBackground: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VC {
        .init()
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
}

extension PresentationTransparentBackground {
    class VC: UIViewController {
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            parent?.view.backgroundColor = .clear
        }
    }
}
#endif
