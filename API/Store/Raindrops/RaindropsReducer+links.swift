import SwiftUI

extension RaindropsReducer {
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
