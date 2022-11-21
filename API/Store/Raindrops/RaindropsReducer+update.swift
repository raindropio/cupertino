extension RaindropsReducer {
    func update(state: inout S, modified: Raindrop) async throws -> ReduxAction? {
        //ignore if no original or nothing modified
        guard let original = state.items[modified.id], modified != original
        else { return nil }
        
        return A.updated(
            try await rest.raindropUpdate(
                original: original,
                modified: modified
            )
        )
    }
    
    //MARK: - Receive updated raindrop from server
    func updated(state: inout S, raindrop: Raindrop) {
        state.items[raindrop.id] = raindrop
        state.updateSegments(raindrop)
    }
}
