import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct UserCollection: CollectionType {
    public var id: Int
    public var title: String
    public var slug: String = ""
    public var description = ""
    public var count = 0
    public var cover: URL?
    public var color: Color? = nil
    public var parent: UserCollection.ID?
    public var created: Date?
    public var lastUpdate: Date?
    public var `public` = false
    public var expanded = false
    public var view = CollectionView.list
    public var sort: Int? = nil
    public var access = CollectionAccess()
    public var collaborators: String?
    public var creatorRef: CreatorRef?
    
    public var systemImage: String {
        "folder"
    }
    
    public var publicPage: URL? {
        self.public ?
            .init(string: "https://raindrop.io/\(creatorRef?.name ?? "")/\(slug)") :
            nil
    }
    
    public var isValid: Bool {
        !title.isEmpty
    }
}

extension UserCollection {
    public static func new(parent: UserCollection.ID? = nil) -> Self {
        .init(
            id: 0,
            title: "",
            parent: parent,
            access: .init(level: .owner, draggable: true)
        )
    }
}
