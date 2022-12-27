extension FiltersReducer {
    func sort(state: inout S, by: FiltersConfig.TagsSort) async throws -> ReduxAction? {
        state.config.tagsSort = by
        state.animation = .init()
        return A.saveConfig
    }
}
