import Foundation

public struct CGroup: Equatable {
    public var title: String
    public var hidden = false
    public var collections: [UserCollection.ID] = []
    
    public static let blank = Self(title: "My collections")
}
