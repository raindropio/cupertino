extension CollectionsReducer {
    func toggle(state: inout S, id: UserCollection.ID) -> ReduxAction? {
        guard let original = state.user[id]
        else { return nil }
        
        //update in place (faster)
        state.user[id]!.expanded = !state.user[id]!.expanded
        
        return A.update(state.user[id]!, original: original)
    }
    
    func toggle(state: inout S, id: CGroup.ID) async throws -> ReduxAction? {
        guard let index = state.groups.firstIndex(where: { $0.id == id })
        else { return nil }
        
        state.groups[index].hidden = !state.groups[index].hidden
        
        return A.saveGroups
    }
}
