extension CollectionsReducer {
    func toggle(state: inout S, id: UserCollection.ID) -> ReduxAction? {
        guard let original = state.user[id]
        else { return nil }
        
        state.user[id]!.expanded = !state.user[id]!.expanded
        
        return A.update(state.user[id]!, original: original)
    }
}
