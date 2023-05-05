extension ConfigReducer {
    func logout(state: inout S) {
        state.collections = .init()
        state.raindrops = .init()
    }
}
