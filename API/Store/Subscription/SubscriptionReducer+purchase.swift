import StoreKit

extension SubscriptionReducer {
    func purchase(state: inout S, userRef: User.ID, product: Product) throws -> ReduxAction? {
        if let current = state.current, current.status != .deactivated {
            throw RestError.invalid("You have active subscription")
        }
                
        return A.purchasing(userRef, product)
    }
}

extension SubscriptionReducer {
    func purchasing(state: S, userRef: User.ID, product: Product) async throws -> ReduxAction? {
        let result = try await product.purchase(options: [
            //.simulatesAskToBuyInSandbox(true),
            .custom(key: "userRef", value: Double(userRef))
        ])
        
        switch result {
        case .success(let verification):
            switch verification {
            //finished successfully
            case .verified(let transaction):
                return A.purchased(transaction)
                
            case .unverified(_, let error):
                throw error
            }
            
        case .pending:
            throw RestError.purchaseHavePending

        case .userCancelled:
            return nil
            
        @unknown default:
            throw RestError.purchaseUnknownStatus
        }
    }
}

extension SubscriptionReducer {
    func purchased(state: S, transaction: StoreKit.Transaction) async throws -> ReduxAction? {
        let receipt = try await getSKReceipt()
        try await rest.subscriptionRestore(receipt: receipt)
        
        await transaction.finish()
        return A.reload
    }
}
