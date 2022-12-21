import StoreKit

public struct SubscriptionState: ReduxState {
    @Cached("su-cu") public var current: Subscription? = nil
    public var products: [Product] = []
    
    public init() { }
}

extension SubscriptionState {
    public var lowestDisplayPrice: String {
        if let result = products.min(by: { $0.price < $1.price }) {
            return result.displayPrice
        }
        return "∞"
    }
}
