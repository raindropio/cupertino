import SwiftUI
import UI
import API

struct CoverPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var raindrop: Raindrop
    
    private var items: [URL] {
        var existing = raindrop.media.compactMap { $0.link }
        let haveScreenshot = existing.contains { $0.host == Rest.base.render.host }

        if !haveScreenshot, let screenshot = Rest.renderImage(raindrop.link) {
            existing.append(screenshot)
        }
        
        return existing
    }
    
    var body: some View {
        ImagePicker(
            items,
            selection: $raindrop.cover,
            width: 92, height: 69
        )
            .equatable()
            .navigationTitle("Cover")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .onChange(of: raindrop.cover) { _ in
                dismiss()
            }
    }
}
