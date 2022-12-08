import SwiftUI
import UniformTypeIdentifiers

struct PlatformDocumentPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: [NSItemProvider]
    var matching: [UTType]

    func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentBrowserViewController {
        let controller = UIDocumentBrowserViewController(forOpening: matching)
        controller.allowsPickingMultipleItems = true
        controller.allowsDocumentCreation = false
        controller.delegate = context.coordinator
        controller.additionalLeadingNavigationBarButtonItems = [
            .init(barButtonSystemItem: .cancel, target: context.coordinator, action: #selector(context.coordinator.cancel))
        ]
        return controller
    }
    
    func updateUIViewController(_ controller: UIDocumentBrowserViewController, context: Context) {
        context.coordinator.update(self)
    }
}

extension PlatformDocumentPicker {
    class Coordinator: NSObject, UIDocumentBrowserViewControllerDelegate {
        private var base: PlatformDocumentPicker
        
        init(_ base: PlatformDocumentPicker) {
            self.base = base
        }
        
        func update(_ base: PlatformDocumentPicker) {
            self.base = base
        }
        
        func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
            base.selection = documentURLs.map {
                .init(item: $0 as NSURL, typeIdentifier: UTType.fileURL.identifier)
            }
        }
        
        @objc func cancel() {
            base.dismiss()
        }
    }
}
