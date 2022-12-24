extension CollectionsReducer {
    func saveGroups(state: inout S) async throws -> ReduxAction? {
        A.groupsUpdated(
            try await rest.collectionGroupsUpdate(
                groups: state.groups
            )
        )
    }
    
    func groupsUpdated(state: inout S, groups: [CGroup]) {
        state.groups = groups
        
        //sort value fix
        for group in groups {
            for (index, id) in group.collections.enumerated() {
                state.user[id]?.sort = index
            }
        }
    }
}
