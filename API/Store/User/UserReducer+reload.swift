extension UserReducer {
    func reload(state: inout S) async throws -> ReduxAction? {
        let user = try await rest.userGet()
        return A.reloaded(user)
    }
    
    func reloaded(state: inout S, user: User) {
        state.me = user
    }
}
