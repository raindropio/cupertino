import SwiftUI
import PhotosUI

public struct MediaPicker<L: View> {
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
    private func content() -> some View {
        ZStack {
            label()
                .opacity(loading ? 0 : 1)
            
            if loading {
                ProgressView().progressViewStyle(.circular)
            }
        }
    }
    
    public var body: some View {
        Group {
            if #available(iOS 16, *) {
                Modern(
                    selection: $selection,
                    loading: $loading,
                    matching: .any(of: matching),
                    label: content
                )
            } else {
                Deprecated(
                    selection: $selection,
                    loading: $loading,
                    matching: .any(of: matching),
                    label: content
                )
            }
        }
            .disabled(loading)
            .animation(.default, value: loading)
    }
}
