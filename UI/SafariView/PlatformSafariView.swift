#if canImport(UIKit)
import SwiftUI
import SafariServices

struct PlatformSafariView: UIViewControllerRepresentable {
    var url: URL
    var button: SafariActivityButton? = nil
    
    func makeCoordinator() -> Coordinator {
        .init()
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        if let button {
            configuration.activityButton = .init(
                templateImage: UIImage(systemName: button.systemImage)!,
                extensionIdentifier: button.extensionIdentifier
            )
        }

        let controller = SFSafariViewController(url: url, configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ safariView: SFSafariViewController, context: Context) {
        context.coordinator.environment = context.environment
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var environment: EnvironmentValues?
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            environment?.dismiss()
        }
    }
}
#endif
