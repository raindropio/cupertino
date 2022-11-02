extension CollectionsReducer {
    func logout(state: inout S) async throws {
        state.user = .init()
    }
}
