extension CollectionsReducer {
    func setView(state: inout S, id: UserCollection.ID, view: CollectionView) -> ReduxAction? {
        if var collection = state.user[id] {
            collection.view = view
            return A.update(collection, fast: true)
        } else {
            state.system[id]?.view = view
            return nil
        }
    }
}
