extension CollectionsReducer {
    /// Reorder inside a group or make collection nested
    func reorder(state: inout S, id: UserCollection.ID, parent: UserCollection.ID?, order: Int) -> ReduxAction? {
        guard var collection = state.user[id]
        else { return nil }
        
        //nested
        if let parent {
            collection.sort = order
        }
        //root
        else {
            
        }

        collection.parent = parent
        
        return A.update(collection)
    }
}
