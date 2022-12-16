import SwiftUI

#if canImport(UIKit)
public extension View {
    func presentationUndimmed(_ largestDetent: UISheetPresentationController.Detent.Identifier) -> some View {
        overlay {
            PresentationUndimmed(largestDetent: largestDetent)
                .opacity(0)
        }
    }
}

fileprivate struct PresentationUndimmed: UIViewControllerRepresentable {
    var largestDetent: UISheetPresentationController.Detent.Identifier
    
    func makeUIViewController(context: Context) -> VC {
        .init(self)
    }

    func updateUIViewController(_ controller: VC, context: Context) {
        controller.update(self)
    }
}

extension PresentationUndimmed {
    class VC: UIViewController {
        var base: PresentationUndimmed
        
        init(_ base: PresentationUndimmed) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        func update(_ base: PresentationUndimmed) {
            self.base = base
            
            if let sheetPresentationController = parent?.sheetPresentationController {
                sheetPresentationController.largestUndimmedDetentIdentifier = base.largestDetent
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
#endif
