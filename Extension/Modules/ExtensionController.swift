import SwiftUI
import API

#if canImport(UIKit)
@objc(ExtensionController)
class ExtensionController: UIViewController, UIAdaptivePresentationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Appearance
        view.backgroundColor = .clear
        #if os(iOS)
        sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        #endif

        //SwiftUI
        let ui = UIHostingController(rootView: ExtensionUI(service: .init(self.extensionContext)))
        ui.view.backgroundColor = .clear
        addChild(ui)
        ui.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ui.view)
        ui.didMove(toParent: self)

        NSLayoutConstraint.activate([
            ui.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            ui.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            ui.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ui.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        presentationController!.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeSheetTransparent()
    }

    func presentationControllerWillDismiss(_ pc: UIPresentationController) {
        makeSheetTransparent()
        pc.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in self.makeSheetTransparent() }
        )
    }

    func makeSheetTransparent() {
        var v: UIView? = view
        for _ in 0..<5 {
            v?.isOpaque = false
            v?.backgroundColor = .clear
            v = v?.superview
        }
   }
}
#else
@objc(ExtensionController)
class ExtensionController: NSViewController {
    override func loadView() {
        self.view = NSHostingView(rootView: ExtensionUI(service: .init(self.extensionContext)))
    }
}
#endif
