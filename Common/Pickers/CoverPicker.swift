import SwiftUI
import UI
import API

struct CoverPicker: View {
    @Environment(\.dismiss) private var dismiss
    var url: URL
    @Binding var selection: URL?
    @Binding var media: [Raindrop.Media]
    
    var body: some View {
        NavigationLink {
            Page(url: url, selection: $selection, media: $media)
        } label: {
            Thumbnail(
                Rest.renderImage(selection ?? url, options: .maxDeviceSize),
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
        var url: URL
        @Binding var selection: URL?
        @Binding var media: [Raindrop.Media]
        
        private var items: [URL] {
            var existing = media.compactMap { $0.link }
            let haveScreenshot = existing.contains { $0.host == Rest.base.render.host }

            if !haveScreenshot, let screenshot = Rest.renderImage(url) {
                existing.append(screenshot)
            }
            
            return existing
        }
        
        var body: some View {
            ImagePicker(
                items,
                selection: $selection,
                width: 92, height: 69
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
