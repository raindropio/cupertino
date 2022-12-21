import StoreKit

extension SubscriptionReducer {
    func products(state: inout S) async throws {
        do {
            state.products = try await Product.products(for: Constants.productIdentifiers)
        }
        catch is CancellationError {
            return
        }
        catch {
            state.products = .init()
            throw error
        }
    }
}
