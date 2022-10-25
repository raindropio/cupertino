public struct UserState: Equatable {
    @Cached("us-me") public var me: User? = nil
    
    public var authorized: Bool {
        me != nil
    }
}
