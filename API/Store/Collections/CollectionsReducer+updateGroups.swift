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
    }
}
