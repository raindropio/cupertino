extension RecentReducer {
    func logout(state: inout S) async throws {
        state.search = .init()
        state.tags = .init()
    }
}
