import Foundation

public struct Collaborator: UserType, Identifiable, Equatable, Hashable {
    public var id: Int
    public var name: String
    public var email = ""
    public var avatar: URL?
    public var level: CollectionAccess.Level
    public var me = false
}
