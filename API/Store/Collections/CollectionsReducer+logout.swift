extension CollectionsReducer {
    func logout(state: inout S) {
        state.user = .init()
    }
}
