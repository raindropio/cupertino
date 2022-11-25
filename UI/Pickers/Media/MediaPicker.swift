import SwiftUI
import PhotosUI

public struct MediaPicker<L: View> {
    @State private var items = [PhotosPickerItem]()
    @State private var loading = false
    
    @Binding var selection: [URL]
    var matching: [PHPickerFilter]
    var label: () -> L
    
    public init(
        selection: Binding<[URL]>,
        matching: [PHPickerFilter],
        label: @escaping () -> L
    ) {
        self._selection = selection
        self.matching = matching
        self.label = label
    }
}

extension MediaPicker: View {
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
    
    public var body: some View {
        PhotosPicker(
            selection: $items,
            matching: .any(of: matching)
        ) {
            ZStack {
                label()
                    .opacity(loading ? 0 : 1)
                
                if loading {
                    ProgressView().progressViewStyle(.circular)
                }
            }
        }
            .task(id: items, priority: .background, convert)
            .disabled(loading)
            .animation(.default, value: loading)
    }
}
