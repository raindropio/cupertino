import SwiftUI
import PhotosUI

public struct DocumentPicker<L: View> {
    @State private var show = false
    
    @Binding var selection: [URL]
    var matching: [UTType]
    var label: () -> L
    
    public init(
        selection: Binding<[URL]>,
        matching: [UTType],
        label: @escaping () -> L
    ) {
        self._selection = selection
        self.matching = matching
        self.label = label
    }
}

extension DocumentPicker: View {
    public var body: some View {
        Button(action: {
            show = true
        }, label: label)
            .sheet(isPresented: $show) {
                PlatformDocumentPicker(
                    selection: $selection,
                    matching: matching
                )
                    .ignoresSafeArea()
            }
    }
}
