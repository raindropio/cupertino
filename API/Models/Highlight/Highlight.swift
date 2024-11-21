import SwiftUI

public struct Highlight: Identifiable, Hashable {
    public var id: String
    public var text: String
    public var note: String = ""
    public var created = Date()
    public var color: Color = .yellow
    public var index: Int?
    public var creatorRef: CreatorRef?
}
