public actor IconsReducer: Reducer {
    public typealias S = IconsState
    public typealias A = IconsAction
    
    var rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload(let filter):
            try await reload(state: &state, filter: filter)
        }
        return nil
    }
}
