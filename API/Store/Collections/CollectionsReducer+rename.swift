extension CollectionsReducer {
    func rename(state: inout S, group: CGroup) -> ReduxAction? {
        //find by collections
        guard let index = state.groups.firstIndex(where: {
            $0.collections == group.collections
        })
        else { return nil }
        
        //ignore if not modified
        guard state.groups[index].title != group.title
        else { return nil }

        state.groups[index].title = group.title
        
        return A.saveGroups
    }
}
