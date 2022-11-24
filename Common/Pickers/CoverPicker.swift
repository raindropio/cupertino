import SwiftUI
import UI
import API

struct CoverPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: URL?
    var media: [Raindrop.Media]
    
    var body: some View {
        NavigationLink {
            Page(selection: $selection, media: media)
        } label: {
            Thumbnail(
                Rest.renderImage(selection, options: .maxDeviceSize),
                height: 96,
                cornerRadius: 3
            )
                .frame(height: 96)
                .frame(maxWidth: .infinity)
        }
            .clearSection()
    }
}

extension CoverPicker {
    struct Page: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var selection: URL?
        var media: [Raindrop.Media]
        
        var body: some View {
            ImagePicker(
                media.compactMap { $0.link },
                selection: $selection,
                width: 80, height: 60
            )
                .equatable()
                .navigationTitle("Cover")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .onChange(of: selection) { _ in
                    dismiss()
                }
        }
    }
}
