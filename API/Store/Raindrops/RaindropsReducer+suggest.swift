import SwiftUI

extension RaindropsReducer {
    func suggest(state: inout S, raindrop: Raindrop) async {
        let key = raindrop.link.compact
        guard state.suggestions[key] == nil else { return }
        
        let found = try? await rest.raindropSuggest(raindrop: raindrop)
        if let found {
            state.suggestions[key] = found
        }
    }
}
