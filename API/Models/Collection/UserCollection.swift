import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct UserCollection: CollectionProtocol {
    public var id: Int
    public var title: String
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
    public var sort = 0
    public var access = CollectionAccess()
    public var collaborators: String?
    public var creatorRef: User?
    
    public var systemImage: String {
        "folder"
    }
}
