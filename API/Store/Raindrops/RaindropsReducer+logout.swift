extension RaindropsReducer {
    func logout(state: inout S) {
        state.items = .init()
        state.segments = .init()
        state.lookups = .init()
        state.suggestions = .init()
    }
}
