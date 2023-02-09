import Foundation

public struct Raindrop: Identifiable, Hashable {
    public var id: Int
    public var link: URL
    public var domain: String = ""
    public var title: String
    public var excerpt = ""
    public var collection: Int = -1
    public var cover: URL?
    public var media = [Media]()
    public var type: RaindropType = .link
    public var tags = [String]()
    public var highlights = [Highlight]()
    public var created = Date()
    public var lastUpdate = Date()
    public var creatorRef: CreatorRef?
    public var important = false
    public var broken = false
    public var duplicate: Raindrop.ID?
    public var file: File?
    public var cache: Cache?
    public var pleaseParse: PleaseParse?
    public var order: Int?
    
    public var favicon: URL? {
        if let host = link.host {
            return Rest.renderFavicon(host, options: .width(48), .height(48))
        } else {
            return nil
        }
    }
    
    public var cacheLink: URL? {
        self.cache != nil ?
            Rest.raindropCacheLink(id) :
            nil
    }
    
    public var isNew: Bool {
        id == 0
    }
}

//Static
extension Raindrop {
    public static func new(link: URL = URL(string: "about:blank")!) -> Self {
        .init(id: 0, link: link, title: "", pleaseParse: .init())
    }
}

//Mutating
extension Raindrop {
    public mutating func enrich(from meta: Self) {
        if title.isEmpty {
            title = meta.title
        }
        
        if excerpt.isEmpty {
            excerpt = meta.excerpt
        }
        
        if cover == nil {
            cover = meta.cover
        }
        
        if media.isEmpty {
            media = meta.media
        }
        
        if type != meta.type {
            type = meta.type
        }
    }
}
