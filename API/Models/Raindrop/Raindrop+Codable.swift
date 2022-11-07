import Foundation

extension Raindrop: Codable {
    //variables that should be in json to send to API
    enum CodingKeys: String, CodingKey {
        case _id
        case title
        case excerpt
        case link
        case collection
        case cover
        case media
        case type
        case tags
        case created
        case lastUpdate
        case creatorRef
        case important
        case broken
        case duplicate
        case file
        case cache
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Swift.type(of: id), forKey: ._id)
        title = try container.decode(Swift.type(of: title), forKey: .title)
        excerpt = (try? container.decode(Swift.type(of: excerpt), forKey: .excerpt)) ?? ""
        link = (try? container.decode(Swift.type(of: link), forKey: .link)) ?? URL(string: "http://incorrect.url")!
        cover = try container.decode(Swift.type(of: cover), forKey: .cover)
        media = (try? container.decode(Swift.type(of: media), forKey: .media)) ?? []
        type = (try? container.decode(Swift.type(of: type), forKey: .type)) ?? .link
        tags = try container.decode(Swift.type(of: tags), forKey: .tags)
        created = try container.decode(Swift.type(of: created), forKey: .created)
        lastUpdate = try container.decode(Swift.type(of: lastUpdate), forKey: .lastUpdate)
        creatorRef = try? container.decode(Swift.type(of: creatorRef), forKey: .creatorRef)
        important = (try? container.decode(Swift.type(of: important), forKey: .important)) ?? false
        broken = (try? container.decode(Swift.type(of: broken), forKey: .broken)) ?? false
        duplicate = try? container.decode(Swift.type(of: duplicate), forKey: .duplicate)
        file = try? container.decode(Swift.type(of: file), forKey: .file)
        cache = try? container.decode(Swift.type(of: cache), forKey: .cache)
        
        if let collectionContainer = try? container.nestedContainer(keyedBy: MongoRef<Int>.CodingKeys.self, forKey: .collection) {
            collection = try collectionContainer.decode(Swift.type(of: collection), forKey: .id)
        } else {
            collection = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(title, forKey: .title)
        try container.encode(excerpt, forKey: .excerpt)
        try container.encode(link, forKey: .link)
        try container.encode(cover, forKey: .cover)
        try container.encode(media, forKey: .media)
        try container.encode(type, forKey: .type)
        try container.encode(tags, forKey: .tags)
        try container.encode(created, forKey: .created)
        try container.encode(lastUpdate, forKey: .lastUpdate)
        try container.encode(creatorRef, forKey: .creatorRef)
        try container.encode(important, forKey: .important)
        try container.encode(broken, forKey: .broken)
        try container.encode(duplicate, forKey: .duplicate)
        try container.encode(file, forKey: .file)
        try container.encode(cache, forKey: .cache)
        
        if collection != nil {
            try container.encode(MongoRef<Int>(collection!), forKey: .collection)
        }
    }
}
