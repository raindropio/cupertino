extension UserReducer {
    func logout(state: inout S) {
        state.me = nil
    }
}
