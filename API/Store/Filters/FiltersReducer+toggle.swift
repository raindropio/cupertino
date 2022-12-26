extension FiltersReducer {
    func toggleConfig(state: inout S, key: WritableKeyPath<FiltersConfig, Bool>) async throws -> ReduxAction? {
        state.config[keyPath: key] = !state.config[keyPath: key]
        state.animation = .init()
        return A.saveConfig
    }
}
