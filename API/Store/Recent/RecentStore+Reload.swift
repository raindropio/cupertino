extension RecentStore {
    func reload(find: FindBy?) async throws {
        guard find == nil || (find!.collectionId == 0 && !find!.isSearching)
        else { return }
        
        async let fetchSearch = rest.recentSearch()
        async let fetchTags = rest.recentTags()
        let (search, tags) = try await (fetchSearch, fetchTags)
        
        try await mutate { state in
            state.search = search
            state.tags = tags
        }
    }
}
