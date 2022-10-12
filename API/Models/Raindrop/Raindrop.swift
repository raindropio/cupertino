import Foundation

public struct Raindrop: Identifiable, Hashable {
    public var id: Int
    public var link: URL
    public var title: String
    public var excerpt = ""
    public var collection: Collection.ID?
    public var cover: Cover?
    public var media = [Media]()
    public var type: `Type` = .link
    public var tags = [String]()
    public var created = Date()
    public var lastUpdate = Date()
    public var creatorRef: User?
    public var important = false
    public var broken = false
    public var duplicate: Int?
    public var file: File?
    public var cache: Cache?
    
    public var favicon: URL? {
        if let host = link.host() {
            return Render.asFaviconUrl(host, options: .width(48), .height(48))
        } else {
            return nil
        }
    }
}
