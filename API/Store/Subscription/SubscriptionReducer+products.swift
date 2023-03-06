import StoreKit

extension SubscriptionReducer {
    func products(state: inout S) async -> ReduxAction {
        let products = try? await Product.products(for: Constants.productIdentifiers)
        return A.productsLoaded(products ?? [])
    }
}

extension SubscriptionReducer {
    func productsLoaded(state: inout S, products: [Product]) {
        state.products = products
    }
}
