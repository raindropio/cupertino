import SwiftUI
import PhotosUI

public struct DocumentPicker {
    @Binding var selection: [NSItemProvider]
    var matching: [UTType]

    public init(
        selection: Binding<[NSItemProvider]>,
        matching: [UTType]
    ) {
        self._selection = selection
        self.matching = matching
    }
}

extension DocumentPicker: View {
    public var body: some View {
        PlatformDocumentPicker(
            selection: $selection,
            matching: matching
        )
            .ignoresSafeArea()
    }
}
