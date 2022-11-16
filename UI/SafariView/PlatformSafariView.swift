import SwiftUI
import SafariServices

struct PlatformSafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        .init()
    }

    func makeUIViewController(context: Context) -> RDSafariViewController {
        let configuration = RDSafariViewController.Configuration()
        //TODO: configuration.activityButton = .init(templateImage: UIImage(systemName: "sun.max")!, extensionIdentifier: "com.bundle.extension")

        let controller = RDSafariViewController(url: url, configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: RDSafariViewController, context: Context) {
        context.coordinator.environment = context.environment
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var environment: EnvironmentValues?
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            environment?.dismiss()
        }
    }
}
