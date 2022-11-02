extension RaindropsReducer {
    func sort(state: inout S, find: FindBy, by: SortBy) -> ReduxAction? {
        let cases = SortBy.someCases(for: find)
        let sort = cases.contains(by) ? by : cases.first!
        
        state[find].sort = sort
        
        return A.load(find)
    }
}
