import SwiftUI
import UI
import API

struct RaindropCoverGrid: View {
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
        ScrollView(.vertical) {
            ImagePicker(
                items,
                selection: $raindrop.cover,
                width: 92, height: 69
            )
                .equatable()
        }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("Cover")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .onChange(of: raindrop.cover) { _ in
                dismiss()
            }
    }
}
