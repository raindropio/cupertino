extension UserReducer {
    func logout(state: inout S) async throws {
        state.me = nil
    }
}
