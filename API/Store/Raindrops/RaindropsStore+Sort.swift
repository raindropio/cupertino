extension RaindropsStore {
    func sort(find: FindBy, by: SortBy) async throws {
        let cases = SortBy.someCases(for: find)
        let sort = cases.contains(by) ? by : cases.first!
        
        try await mutate { state in
            state[find].sort = sort
        }
        
        dispatch(.reload(find))
    }
}
