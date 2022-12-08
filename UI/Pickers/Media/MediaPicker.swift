import SwiftUI
import PhotosUI

public struct MediaPicker {
    @Binding var selection: [NSItemProvider]
    var matching: [PHPickerFilter]
    
    public init(
        selection: Binding<[NSItemProvider]>,
        matching: [PHPickerFilter]
    ) {
        self._selection = selection
        self.matching = matching
    }
}

extension MediaPicker: View {
    public var body: some View {
        PlatformMediaPicker(
            results: $selection,
            filter: .any(of: matching)
        )
            .ignoresSafeArea()
    }
}
