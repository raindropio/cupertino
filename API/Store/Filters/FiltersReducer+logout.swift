extension FiltersReducer {
    func logout(state: inout S) async throws {
        state.simple = .init()
        state.tags = .init()
        state.created = .init()
    }
}
