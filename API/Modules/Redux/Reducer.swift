public protocol Reducer: Actor {
    associatedtype A: ReduxAction
    associatedtype S: ReduxState
    
    init()
    
    func reduce(state: inout S, action: A) async throws -> ReduxAction?
    
    //optional
    func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction?
    func reduce(state: inout S, error: Error) async throws -> ReduxAction?
}

//default implementation
extension Reducer {
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        return nil
    }
    
    public func reduce(state: inout S, error: Error) async throws -> ReduxAction? {
        return nil
    }
}
