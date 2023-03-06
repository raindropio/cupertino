import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

public extension View {
    func photoImporter(isPresented: Binding<Bool>, onCompletion: @escaping ([NSItemProvider]) -> Void) -> some View {
        modifier(PI(isPresented: isPresented, onCompletion: onCompletion))
    }
}

fileprivate struct PI: ViewModifier {
    @Binding var isPresented: Bool
    var onCompletion: ([NSItemProvider]) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                PlatformPhotoPicker {
                    onCompletion($0)
                    isPresented = false
                }
            }
    }
}

fileprivate struct PlatformPhotoPicker: UIViewControllerRepresentable {
    var filter: PHPickerFilter?
    var onCompletion: ([NSItemProvider]) -> Void

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

extension PlatformPhotoPicker {
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private var base: PlatformPhotoPicker
        
        init(_ base: PlatformPhotoPicker) {
            self.base = base
        }
        
        func update(_ base: PlatformPhotoPicker) {
            self.base = base
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            base.onCompletion(results.map { $0.itemProvider })
                        
            if !results.isEmpty {
                picker.dismiss(animated: true);
            }
        }
    }
}
