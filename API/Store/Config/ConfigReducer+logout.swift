extension ConfigReducer {
    func logout(state: inout S) {
        state.raindrops = .init()
    }
}
