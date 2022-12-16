import SwiftUI

extension RaindropsReducer {
    func addHighlight(state: inout S, url: URL, highlight: Highlight) async throws -> ReduxAction? {
        var raindrop = (try await rest.raindropGet(link: url)) ?? .new(link: url)
        raindrop.highlights.append(highlight)
        
        return raindrop.id > 0 ? A.update(raindrop) : A.create(raindrop)
    }
    
    func updateHighlight(state: inout S, highlight: Highlight) async throws -> ReduxAction? {
        var id: Raindrop.ID?
        var index: Array<Highlight>.Index?
        
        for item in state.items {
            let found = item.value.highlights.firstIndex { $0.id == highlight.id }
            if let found {
                id = item.key
                index = found
                break
            }
        }
        
        guard
            let id, let index,
            var raindrop = state.items[id]
        else { return nil }
        
        raindrop.highlights[index] = highlight
        
        return A.update(raindrop)
    }
    
    func deleteHighlight(state: inout S, highlightId: Highlight.ID) async throws -> ReduxAction? {
        return HighlightsAction.update(.init(id: highlightId, text: "")) //making text empty removes highlight
    }
}
