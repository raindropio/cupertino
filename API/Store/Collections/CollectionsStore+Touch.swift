extension CollectionsStore {
    func touch<V>(id: UserCollection.ID, keyPath: WritableKeyPath<UserCollection, V>, value: V) async throws {
        guard var collection = await state.user[id]
        else { return }
        
        collection[keyPath: keyPath] = value
        
        dispatch(.update(collection))
    }
}
