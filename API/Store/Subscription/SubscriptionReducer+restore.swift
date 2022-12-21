import StoreKit

extension SubscriptionReducer {
    func restore(state: inout S) async throws -> ReduxAction? {
        let receipt = try await getSKReceipt()
        try await rest.subscriptionRestore(receipt: receipt)
        return A.reload
    }
}
