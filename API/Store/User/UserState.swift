public struct UserState: Equatable {
    @Cached("us-me") var me: User? = nil
    
    public var authorized: Bool {
        me != nil
    }
}
