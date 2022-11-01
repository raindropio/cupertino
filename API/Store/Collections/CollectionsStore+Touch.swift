extension CollectionsStore {
    //user collection
    func touch<V>(id: UserCollection.ID, keyPath: WritableKeyPath<UserCollection, V>, value: V) async throws {
        guard var collection = await state.user[id]
        else { return }
        
        collection[keyPath: keyPath] = value
        
        dispatch(.update(collection))
    }
    
    //system collection
    func touch<V>(id: SystemCollection.ID, keyPath: WritableKeyPath<SystemCollection, V>, value: V) async throws {
        try await mutate {
            $0.system[id]?[keyPath: keyPath] = value
        }
    }
}
