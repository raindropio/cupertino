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

fileprivate struct PlatformPhotoPicker {
    var filter: PHPickerFilter?
    var onCompletion: ([NSItemProvider]) -> Void
    
    func makeViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = 999
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateViewController(_ picker: PHPickerViewController, context: Context) {
        context.coordinator.update(self)
    }
}

#if canImport(AppKit)
extension PlatformPhotoPicker: NSViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    func makeNSViewController(context: Context) -> PHPickerViewController {
        makeViewController(context: context)
    }
    
    func updateNSViewController(_ picker: PHPickerViewController, context: Context) {
        updateViewController(picker, context: context)
    }
}
#else
extension PlatformPhotoPicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        makeViewController(context: context)
    }
    
    func updateUIViewController(_ picker: PHPickerViewController, context: Context) {
        updateViewController(picker, context: context)
    }
}
#endif

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
                #if canImport(UIKit)
                picker.dismiss(animated: true);
                #endif
            }
        }
    }
}
