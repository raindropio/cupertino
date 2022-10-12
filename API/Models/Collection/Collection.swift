import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct Collection: Identifiable, Hashable {
    public var id: Int
    public var title: String
    public var description = ""
    public var count = 0
    public var cover: URL?
    public var color: Color? = nil
    public var parent: Collection.ID?
    public var created: Date?
    public var lastUpdate: Date?
    public var `public` = false
    public var expanded = false
    public var view: View?
    public var sort = 0
    public var access = Access()
    public var collaborators: String?
    public var creatorRef: User?
    
    public var systemImage: String {
        "folder"
    }
}
