extension RaindropsReducer {
    func logout(state: inout S) async throws {
        state.items = .init()
        state.segments = .init()
    }
}
