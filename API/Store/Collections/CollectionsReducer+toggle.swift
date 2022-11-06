extension CollectionsReducer {
    func toggle(state: inout S, id: UserCollection.ID) -> ReduxAction? {
        guard var collection = state.user[id]
        else { return nil }
        
        collection.expanded = !collection.expanded
        
        return A.update(collection, fast: true)
    }
}
