extension CollectionsReducer {
    func deleteMany(state: inout S, ids: Set<UserCollection.ID>, nested: Bool) async throws -> ReduxAction? {
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
        
        try await rest.collectionDeleteMany(ids: targets)
        return A.reload
    }
}

extension CollectionsReducer {
    //remove group
    func delete(state: inout S, group: CGroup) -> ReduxAction? {
        guard let index = state.groups.firstIndex(of: group)
        else { return nil }
        
        state.groups.remove(at: index)
        state.clean()
        
        return A.saveGroups
    }
}
