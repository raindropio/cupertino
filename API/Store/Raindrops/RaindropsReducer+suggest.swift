import SwiftUI

extension RaindropsReducer {
    func suggest(state: inout S, raindrop: Raindrop) async -> ReduxAction? {
        let key = raindrop.link.compact
        guard state.suggestions[key] == nil else { return nil }
        
        if let suggestions = try? await rest.raindropSuggest(raindrop: raindrop) {
            return A.suggested(raindrop.link, suggestions)
        }
        return nil
    }
    
    func suggested(state: inout S, url: URL, suggestions: RaindropSuggestions) {
        state.suggestions[url.compact] = suggestions
    }
}
