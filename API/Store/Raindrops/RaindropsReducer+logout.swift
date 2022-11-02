extension RaindropsReducer {
    func logout(state: inout S) {
        state.items = .init()
        state.segments = .init()
    }
}
