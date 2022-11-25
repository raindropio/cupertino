import SwiftUI
import UniformTypeIdentifiers

struct PlatformDocumentPicker: UIViewControllerRepresentable {
    @Binding var selection: [URL]
    var matching: [UTType]

    func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: matching, asCopy: true)
        controller.allowsMultipleSelection = true
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.update(self)
    }
}

extension PlatformDocumentPicker {
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        private var base: PlatformDocumentPicker
        
        init(_ base: PlatformDocumentPicker) {
            self.base = base
        }
        
        func update(_ base: PlatformDocumentPicker) {
            self.base = base
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            base.selection = urls
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            base.selection = .init()
        }
    }
}
