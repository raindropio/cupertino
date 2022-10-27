import Foundation

public struct CGroup: Identifiable, Equatable {
    public var id: String { "g\(sort)" }
    public var title: String
    public var hidden = false
    public var sort = 0
    public var collections: [UserCollection.ID] = []
}
