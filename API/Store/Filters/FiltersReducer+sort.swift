extension FiltersReducer {
    func sort(state: inout S, by: TagsSort) async throws -> ReduxAction? {
        state.sort = by
        state.animation = .init()
        return A.reload()
    }
}
