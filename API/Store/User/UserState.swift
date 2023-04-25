public struct UserState: ReduxState {
    @Persisted("us-me") public var me: User? = nil
    
    public init() { }
    
    public var authorized: Bool {
        me != nil
    }
}
