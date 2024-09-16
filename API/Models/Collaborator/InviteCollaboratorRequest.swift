public struct InviteCollaboratorRequest: Equatable {
    public var level: CollectionAccess.Level
    
    public init(level: CollectionAccess.Level) {
        self.level = level
    }
    
    public var isValid: Bool {
        level >= .viewer && level < .owner
    }
}
