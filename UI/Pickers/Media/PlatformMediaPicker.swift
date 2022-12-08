import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct PlatformMediaPicker: UIViewControllerRepresentable {
    @Binding var results: [NSItemProvider]
    var filter: PHPickerFilter?

    func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = 999
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ picker: PHPickerViewController, context: Context) {
        context.coordinator.update(self)
    }
}

extension PlatformMediaPicker {
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private var base: PlatformMediaPicker
        
        init(_ base: PlatformMediaPicker) {
            self.base = base
        }
        
        func update(_ base: PlatformMediaPicker) {
            self.base = base
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty
            else { picker.dismiss(animated: true); return }
            
            base.results = results.map { $0.itemProvider }
        }
    }
}
