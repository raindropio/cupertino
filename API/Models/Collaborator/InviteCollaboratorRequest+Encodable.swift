extension InviteCollaboratorRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case emails
        case role
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(level)", forKey: .role)
    }
}
