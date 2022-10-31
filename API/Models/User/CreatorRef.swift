import Foundation

public struct CreatorRef: Identifiable, Equatable, Hashable, Codable {
    public var id: User.ID { _id }
    public var name = ""
    public var avatar: URL?
    public var email = ""
    
    var _id: User.ID
}
