import SwiftUI

extension RaindropsReducer {
    func enrich(state: S, raindrop: Binding<Raindrop>) async throws {
        guard raindrop.wrappedValue.isNew else { return }
        
        let meta = try await rest.importUrlParse(raindrop.wrappedValue.link)
        guard raindrop.wrappedValue.isNew else { return }
        
        var changed = false
        
        if raindrop.wrappedValue.title.isEmpty {
            raindrop.wrappedValue.title = meta.title
            changed = true
        }
        
        if raindrop.wrappedValue.excerpt.isEmpty {
            raindrop.wrappedValue.excerpt = meta.excerpt
            changed = true
        }
        
        if raindrop.wrappedValue.cover == nil {
            raindrop.wrappedValue.cover = meta.cover
            changed = true
        }
        
        if raindrop.wrappedValue.media.isEmpty {
            raindrop.wrappedValue.media = meta.media
            changed = true
        }
        
        if raindrop.wrappedValue.type != meta.type {
            raindrop.wrappedValue.type = meta.type
            changed = true
        }
        
        if changed {
            raindrop.wrappedValue.lastUpdate = .now
        }
    }
}
