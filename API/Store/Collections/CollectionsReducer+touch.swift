extension CollectionsReducer {
    //user collection
    func touch<V>(state: inout S, id: UserCollection.ID, keyPath: WritableKeyPath<UserCollection, V>, value: V) async throws -> ReduxAction? {
        guard var collection = state.user[id]
        else { return nil }
        
        collection[keyPath: keyPath] = value
        
        return A.update(collection)
    }
    
    //system collection
    func touch<V>(state: inout S, id: SystemCollection.ID, keyPath: WritableKeyPath<SystemCollection, V>, value: V) {
        state.system[id]?[keyPath: keyPath] = value
    }
}
