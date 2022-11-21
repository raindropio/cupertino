extension RaindropsReducer {
    func reorder(state: inout S, id: Raindrop.ID, order: Int) -> ReduxAction? {
        guard var raindrop = state.items[id]
        else { return nil }
        
        raindrop.order = order
        state.reorderSegments(raindrop)
        
        return A.update(raindrop)
    }
}
