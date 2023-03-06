public actor SubscriptionReducer: Reducer {
    public typealias S = SubscriptionState
    public typealias A = SubscriptionAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        //load
        case .load:
            return load(state: &state)
            
        case .reload:
            return await reload(state: &state)

        case .reloaded(let subscription):
            reloaded(state: &state, subscription: subscription)
            
        case .reloadFailed(let error):
            try reloadFailed(state: &state, error: error)
            
        case .products:
            return await products(state: &state)
            
        case .productsLoaded(let p):
            productsLoaded(state: &state, products: p)
            
        //purchase
        case .purchase(let userRef, let product):
            return try purchase(state: &state, userRef: userRef, product: product)
            
        case .purchasing(let userRef, let product):
            return try await purchasing(state: &state, userRef: userRef, product: product)
            
        case .purchased(let transaction):
            return try await purchased(state: &state, transaction: transaction)
            
        //restore
        case .restore:
            return try await restore(state: &state)
        }
        return nil
    }
    
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        if let action = action as? AuthAction {
            switch action {
            case .logout:
                logout(state: &state)
                
            default:
                break
            }
        }
        
        if let action = action as? UserAction {
            switch action {
            case .reloaded(_):
                return load(state: &state)
                
            default:
                break
            }
        }
        
        return nil
    }
}
