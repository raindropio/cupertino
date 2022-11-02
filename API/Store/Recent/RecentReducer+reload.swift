extension RecentReducer {
    func reload(state: inout S, find: FindBy) async throws {
        guard find.collectionId == 0 && !find.isSearching
        else { return }
        
        async let fetchSearch = rest.recentSearch()
        async let fetchTags = rest.recentTags()
        let (search, tags) = try await (fetchSearch, fetchTags)
        
        state.search = search
        state.tags = tags
    }
}
