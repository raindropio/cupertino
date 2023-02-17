public struct InviteCollaboratorRequest {
    public var email: String
    public var level: CollectionAccess.Level
    
    public init(email: String = "", level: CollectionAccess.Level) {
        self.email = email
        self.level = level
    }
    
    public var isValid: Bool {
        email.contains("@") && email.contains(".") && email.count > 2
            && level >= .viewer && level < .owner
    }
}
