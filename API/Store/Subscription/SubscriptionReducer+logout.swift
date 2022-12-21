extension SubscriptionReducer {
    func logout(state: inout S) {
        state.current = nil
    }
}
