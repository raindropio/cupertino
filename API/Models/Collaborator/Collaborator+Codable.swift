import Foundation

extension Collaborator: Codable {
    //variables that should be in json of API
    enum CodingKeys: String, CodingKey {
        case _id
        case name
        case email
        case avatar
        case level
        case me
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(type(of: id), forKey: ._id)
        name = try container.decode(type(of: name), forKey: .name)
        email = (try? container.decode(type(of: email), forKey: .email)) ?? ""
        avatar = try? container.decode(type(of: avatar), forKey: .avatar)
        level = (try? container.decode(type(of: level), forKey: .level)) ?? .noAccess
        me = (try? container.decode(type(of: me), forKey: .me)) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(level, forKey: .level)
        try container.encode(me, forKey: .me)
    }
}
