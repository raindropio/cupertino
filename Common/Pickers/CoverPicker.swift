import SwiftUI
import UI
import API

struct CoverPicker: View {
    @Namespace private var namespace
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: URL?
    var media: [Raindrop.Media]
    
    var body: some View {
        NavigationLink {
            Page(selection: $selection, media: media, namespace: namespace)
        } label: {
            Thumbnail(
                selection,//Rest.renderImage(selection, options: .maxDeviceSize),
                height: 96,
                cornerRadius: 3
            )
                .frame(height: 96)
                .frame(maxWidth: .infinity)
                .matchedGeometryEffect(id: selection, in: namespace)
        }
            .clearSection()
    }
}

extension CoverPicker {
    struct Page: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var selection: URL?
        var media: [Raindrop.Media]
        var namespace: Namespace.ID?
        
        var body: some View {
            ImagePicker(
                media.compactMap { $0.link },
                selection: $selection,
                namespace: namespace,
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
