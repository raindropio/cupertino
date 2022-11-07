import Foundation

public struct CGroup: Identifiable, Equatable {
    public var id: UUID
    public var title: String
    public var hidden = false
    public var collections: [UserCollection.ID] = []
}
