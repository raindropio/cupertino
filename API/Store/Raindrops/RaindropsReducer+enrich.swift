import SwiftUI

extension RaindropsReducer {
    func enrich(state: S, raindrop: Binding<Raindrop>) async throws {
        guard raindrop.wrappedValue.isNew else { return }
        
        let meta = try await rest.importUrlParse(raindrop.wrappedValue.link)
        guard raindrop.wrappedValue.isNew else { return }
        
        if raindrop.wrappedValue.title.isEmpty {
            raindrop.wrappedValue.title = meta.title
        }
        
        if raindrop.wrappedValue.excerpt.isEmpty {
            raindrop.wrappedValue.excerpt = meta.excerpt
        }
        
        if raindrop.wrappedValue.cover == nil {
            raindrop.wrappedValue.cover = meta.cover
        }
        
        if raindrop.wrappedValue.media.isEmpty {
            raindrop.wrappedValue.media = meta.media
        }
        
        if raindrop.wrappedValue.type != meta.type {
            raindrop.wrappedValue.type = meta.type
        }
    }
}
