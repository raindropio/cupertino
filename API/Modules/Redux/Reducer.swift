public protocol Reducer: Actor {
    associatedtype A: ReduxAction
    associatedtype S: ReduxState
    
    init()
    
    func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction?
    func middleware(state: S, action: ReduxAction) async throws -> ReduxAction?
    func middleware(state: S, error: Error) async throws -> ReduxAction?
}

//default implementation
extension Reducer {
    public func middleware(state: S, error: Error) async throws -> ReduxAction? {
        return nil
    }
}
