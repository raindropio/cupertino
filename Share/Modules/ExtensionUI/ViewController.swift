import SwiftUI
import UIKit

class ShareViewController: UIViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SwiftUI
        let ui = UIHostingController(rootView: ExtensionUI(service: .init(self.extensionContext)))
        ui.sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
