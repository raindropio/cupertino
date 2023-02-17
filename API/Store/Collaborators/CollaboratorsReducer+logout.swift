extension CollaboratorsReducer {
    func logout(state: inout S) {
        state.users = .init()
        state.loading = .init()
    }
}
