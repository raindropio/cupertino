public final class LogReducer: Reducer {
    public typealias S = LogState
    public typealias A = LogAction
    
    public init() {}
}

extension LogReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        //print(type(of: action), action)
        return nil
    }
    
    public func middleware(state: S, action: ReduxAction) async throws -> ReduxAction? {
        return nil
    }
    
    public func middleware(state: S, error: Error) async throws -> ReduxAction? {
        print("Store Error:", error)
        return nil
    }
}
