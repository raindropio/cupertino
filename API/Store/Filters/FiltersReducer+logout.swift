extension FiltersReducer {
    func logout(state: inout S) {
        state.simple = .init()
        state.tags = .init()
        state.created = .init()
    }
}
