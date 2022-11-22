extension CollectionsReducer {
    func reorder(state: inout S, id: UserCollection.ID, parent: UserCollection.ID?, order: Int) -> ReduxAction? {
        guard var collection = state.user[id]
        else { return nil }
        
        collection.parent = parent
        collection.sort = order
        
        return A.update(collection)
    }
}

extension CollectionsReducer {
    func reorderMany(state: inout S, by: UpdateCollectionsRequest.Sort) -> ReduxAction? {
        return A.updateMany(
            .init(sort: by)
        )
    }
}
