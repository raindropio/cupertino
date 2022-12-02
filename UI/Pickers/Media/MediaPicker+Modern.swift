import SwiftUI
import PhotosUI

extension MediaPicker {
    @available(iOS 16, *)
    struct Modern<L: View>: View {
        @State private var items = [PhotosPickerItem]()
        
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
                //TODO: HEIF doesn't work
                if let data = try? await item.loadTransferable(type: Data.self) {
                    let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                    if (try? data.write(to: url)) != nil {
                        selection.append(url)
                    }
                }
            }
            self.selection = selection
        }
        
        var body: some View {
            PhotosPicker(
                selection: $items,
                matching: matching,
                label: label
            )
                .task(id: items, priority: .background, convert)
        }
    }
}
