extension RecentReducer {
    func logout(state: inout S) {
        state.search = .init()
        state.tags = .init()
    }
}
