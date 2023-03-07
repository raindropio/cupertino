extension RecentReducer {
    func reload(state: S, find: FindBy) async throws -> ReduxAction? {
        guard find.collectionId == 0 && !find.isSearching
        else { return nil }
        
        async let fetchSearch = rest.recentSearch()
        async let fetchTags = rest.recentTags()
        let (search, tags) = try await (fetchSearch, fetchTags)
        
        return A.reloaded(find, search: search, tags: tags)
    }
}

extension RecentReducer {
    func reloaded(state: inout S, find: FindBy, search: [String], tags: [String]) {
        if state.search != search || state.tags != tags {
            state.animation = .init()
        }
        
        state.search = search
        state.tags = tags
    }
}
