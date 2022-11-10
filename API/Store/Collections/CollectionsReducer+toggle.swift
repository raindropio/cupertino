extension CollectionsReducer {
    func toggle(state: inout S, id: UserCollection.ID) -> ReduxAction? {
        guard let original = state.user[id]
        else { return nil }
        
        //update in place (faster)
        state.user[id]!.expanded = !state.user[id]!.expanded
        
        return A.update(state.user[id]!, original: original)
    }
    
    func toggle(state: inout S, group: CGroup) -> ReduxAction? {
        guard let index = state.groups.firstIndex(of: group)
        else { return nil }
        
        state.groups[index].hidden = !state.groups[index].hidden
        
        return A.saveGroups
    }
}

extension CollectionsReducer {
    func toggleMany(state: inout S) -> ReduxAction? {
        let anyParent = state.user.first { $0.value.parent != nil }?.value.parent
        let anyExpanded = state.user.first { $0.value.id == anyParent }?.value.expanded ?? false
        
        return A.updateMany(
            .init(expanded: !anyExpanded)
        )
    }
}
