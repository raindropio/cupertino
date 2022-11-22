import SwiftUI
import UI
import API

struct CoverPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: Raindrop.Cover?
    var media: [Raindrop.Media]
    
    var body: some View {
        NavigationLink {
            Page(selection: $selection, media: media)
        } label: {
            Thumbnail(selection?.best, height: 96, cornerRadius: 3)
                .frame(height: 96)
                .frame(maxWidth: .infinity)
        }
            .clearSection()
    }
}

extension CoverPicker {
    struct Page: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var selection: Raindrop.Cover?
        var media: [Raindrop.Media]
        
        var body: some View {
            ImagePicker(
                media.compactMap { $0.link?.original },
                selection: .init { selection?.original } set: { selection = .init($0) },
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
