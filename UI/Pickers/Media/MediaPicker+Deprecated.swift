import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

extension MediaPicker {
    @available(iOS, deprecated: 16.0)
    struct Deprecated<L: View>: View {
        @State private var show = false
        @State private var items = [PHPickerResult]()

        @Binding var selection: [URL]
        @Binding var loading: Bool
        var matching: PHPickerFilter?
        var label: () -> L
        
        @Sendable
        private func convert() async {
            loading = true
            defer { loading = false }
            
            var selection = [URL]()
            
            for item in items {
                let image = (try? await item.itemProvider.loadObject(ofClass: UIImage.self)) as? UIImage
                
                if let image {
                    let url = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("png")
                    if (try? image.pngData()?.write(to: url)) != nil {
                        selection.append(url)
                    }
                }
            }
            
            self.selection = selection
        }
        
        var body: some View {
            Button(action: {
                show = true
            }, label: label)
                .task(id: items, priority: .background, convert)
                .sheet(isPresented: $show) {
                    PlatformPhotoPicker(
                        results: $items,
                        filter: matching
                    )
                        .ignoresSafeArea()
                }
        }
    }
}

fileprivate struct PlatformPhotoPicker: UIViewControllerRepresentable {
    @Binding var results: [PHPickerResult]
    var filter: PHPickerFilter?

    func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = 999
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
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
            base.results = results
            picker.dismiss(animated: true)
        }
    }
}

fileprivate extension NSItemProvider {
    func loadObject(ofClass aClass: NSItemProviderReading.Type) async throws -> NSItemProviderReading? {
        return try await withCheckedThrowingContinuation { continuation in
            loadObject(ofClass: aClass) { result, error in
                if let result {
                    continuation.resume(returning: result)
                } else if let error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
