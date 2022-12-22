extension SubscriptionReducer {
    func load(state: inout S) -> ReduxAction? {
        A.reload
    }
}

extension SubscriptionReducer {
    func reload(state: inout S) async throws -> ReduxAction? {
        do {
            let subscription = try await rest.subscriptionGet()
            guard subscription.status != .unknown else { return nil }
            return A.reloaded(subscription)
        }
        catch is CancellationError {
            return nil
        }
        catch {
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
