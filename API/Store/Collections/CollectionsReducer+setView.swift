extension CollectionsReducer {
    func setView(state: inout S, id: UserCollection.ID, view: CollectionView) -> ReduxAction? {
        //user collection
        if var collection = state.user[id] {
            collection.view = view
            return A.update(collection)
        }
        //system collection
        else {
            state.system[id]?.view = view
            return nil
        }
    }
}
