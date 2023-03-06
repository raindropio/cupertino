extension FiltersReducer {
    func sort(state: inout S, by: TagsSort) -> ReduxAction? {
        state.sort = by
        state.animation = .init()
        return A.reload()
    }
}
