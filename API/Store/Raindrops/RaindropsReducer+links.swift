import SwiftUI

extension RaindropsReducer {
    func links(state: S) async -> ReduxAction? {
        let links = try? await rest.raindropsLinks()
        guard let links else { return nil }
        
        var lookups: [URL: Raindrop.ID] = [:]
        links.forEach {
            lookups[$0.key.compact] = $0.value
        }
        
        return A.linksLoaded(lookups)
    }
    
    func linksLoaded(state: inout S, lookups: [URL: Raindrop.ID]) {
        state.lookups = lookups
    }
}
