extension ConfigReducer {
    func load(state: S) async -> ReduxAction? {
        let config: S? = try? await rest.configGet()
        guard let config else { return nil }
        return A.reloaded(config)
    }
    
    func reloaded(state: inout S, config: S) {
        state = config
    }
}
