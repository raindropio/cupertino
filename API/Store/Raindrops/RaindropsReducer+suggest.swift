import SwiftUI

extension RaindropsReducer {
    func suggest(state: S, raindrop: Raindrop) async -> ReduxAction? {
        if let suggestions = try? await rest.raindropSuggest(raindrop: raindrop) {
            return A.suggested(raindrop.link, suggestions)
        }
        return nil
    }
    
    func suggested(state: inout S, url: URL, suggestions: RaindropSuggestions) {
        state.suggestions[url.compact] = suggestions
    }
}
