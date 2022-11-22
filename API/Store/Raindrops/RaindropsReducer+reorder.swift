extension RaindropsReducer {
    func reorder(state: inout S, id: Raindrop.ID, to: Int?, order: Int) -> ReduxAction? {
        guard var raindrop = state.items[id]
        else { return nil }
        
        //move to new collection
        if let to {
            raindrop.collection = to
        }
        
        //set order
        raindrop.order = order
        state.reorderSegments(raindrop)
        
        return A.update(raindrop)
    }
}
