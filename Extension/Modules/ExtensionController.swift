import SwiftUI
import Sentry
import API

#if canImport(UIKit)
@objc(ExtensionController)
class ExtensionController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sentry
        SentrySDK.start { options in
            options.dsn = Constants.sentryDsn
            options.debug = true
            options.tracesSampleRate = 0.1
        }
        
        //Appearance
        view.backgroundColor = .clear
        sheetPresentationController?.largestUndimmedDetentIdentifier = .medium

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
    }
}
#else
@objc(ExtensionController)
class ExtensionController: NSViewController {
    override func loadView() {
        //sentry
        SentrySDK.start { options in
            options.dsn = Constants.sentryDsn
            options.debug = true
            options.tracesSampleRate = 0.1
        }
        
        self.view = NSHostingView(rootView: ExtensionUI(service: .init(self.extensionContext)))
    }
}
#endif
