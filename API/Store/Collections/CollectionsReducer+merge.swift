extension CollectionsReducer {
    func merge(state: S, ids: Set<UserCollection.ID>, nested: Bool) async throws -> ReduxAction? {
        var targets = Set<UserCollection.ID>()
        for id in ids {
            guard id > 0 else { continue }
            targets.insert(id)
            if nested {
                targets.formUnion(
                    Set(state.childrensRecursive(of: id).map { $0.id })
                )
            }
        }
        
        guard !targets.isEmpty else { return nil }
        
        try await rest.collectionMerge(ids: targets, to: targets.first!)
        return A.reload
    }
}
