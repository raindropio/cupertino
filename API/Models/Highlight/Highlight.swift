import SwiftUI

public struct Highlight: Identifiable, Hashable {
    public var id: String
    public var text: String
    public var note: String = ""
    public var created = Date()
    public var color: Color = .yellow
    public var position: Int = 0
    public var creatorRef: CreatorRef?
}
