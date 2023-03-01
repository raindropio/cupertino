import SwiftUI

extension RaindropsReducer {
    func lookup(state: inout S, url: URL) async {
        await links(state: &state)
        
        let id = state.lookups[url.compact]
        guard let id else { return }
        
        let item = try? await rest.raindropGet(id: id)
        if let item {
            state.items[item.id] = item
        }
    }
    
    func links(state: inout S) async {
        let links = try? await rest.raindropsLinks()
        guard let links else { return }
        
        var lookups: [URL: Raindrop.ID] = [:]
        links.forEach {
            lookups[$0.key.compact] = $0.value
        }
        state.lookups = lookups
    }
}
