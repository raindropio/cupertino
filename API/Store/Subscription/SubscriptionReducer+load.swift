extension SubscriptionReducer {
    func load(state: inout S) -> ReduxAction? {
        A.reload
    }
}

extension SubscriptionReducer {
    func reload(state: S) async -> ReduxAction? {
        do {
            let subscription = try await rest.subscriptionGet()
            guard subscription.status != .unknown else { return nil }
            return A.reloaded(subscription)
        }
        catch {
            return A.reloadFailed(error)
        }
    }
}

extension SubscriptionReducer {
    func reloadFailed(state: inout S, error: Error) throws {
        switch error {
        case is CancellationError:
            break
        default:
            state.current = nil
            throw error
        }
    }
}

extension SubscriptionReducer {
    func reloaded(state: inout S, subscription: Subscription) {
        state.current = subscription
    }
}
