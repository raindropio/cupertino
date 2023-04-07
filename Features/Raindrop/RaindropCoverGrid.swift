import SwiftUI
import UI
import API
import Backport

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
            .backport.scrollBounceBehavior(.basedOnSize, axes: [.horizontal, .vertical])
            .ignoresSafeArea(.keyboard)
            .navigationTitle("Cover")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #else
            .frame(idealHeight: 300)
            #endif
            .toolbar {
                ToolbarItem {
                    AddButton(raindrop: $raindrop)
                }
            }
            .onChange(of: raindrop.cover) { _ in
                dismiss()
            }
    }
}

extension RaindropCoverGrid {
    struct AddButton: View {
        @State private var show = false
        @State private var url = ""
        @Binding var raindrop: Raindrop
        
        private func action() {
            guard let url = URL(string: url) else { return }
            guard !raindrop.media.contains(where: { $0.link == url }) else { return }
            
            raindrop.media.append(.init(url))
            raindrop.cover = url
        }

        var body: some View {
            Button { show.toggle() } label: {
                Image(systemName: "plus")
            }
                .alert("New cover", isPresented: $show) {
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                        .submitLabel(.done)
                    
                    Button("Add", action: action)
                    Button("Cancel", role: .cancel) {}
                } message: {}
        }
    }
}
