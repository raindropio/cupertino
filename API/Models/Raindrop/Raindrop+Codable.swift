import Foundation

extension Raindrop: Codable, EncodableWithConfiguration {
    enum CodingKeys: String, CodingKey {
        case _id
        case title
        case excerpt
        case link
        case domain
        case collection
        case cover
        case media
        case type
        case tags
        case reminder
        case highlights
        case created
        case lastUpdate
        case creatorRef
        case important
        case broken
        case duplicate
        case file
        case cache
        case pleaseParse
        case order
    }
    
    public enum EncodeConfiguration {
        case all
        case modified(from: Raindrop)
        case new
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = (try? container.decode(Swift.type(of: id), forKey: ._id)) ?? 0
        title = (try? container.decode(Swift.type(of: title), forKey: .title)) ?? ""
        excerpt = (try? container.decode(Swift.type(of: excerpt), forKey: .excerpt)) ?? ""
        link = (try? container.decode(Swift.type(of: link), forKey: .link)) ?? URL(string: "http://incorrect.url")!
        domain = (try? container.decode(Swift.type(of: domain), forKey: .domain)) ?? ""
        cover = try? container.decode(Swift.type(of: cover), forKey: .cover)
        media = (try? container.decode(Swift.type(of: media), forKey: .media)) ?? []
        type = (try? container.decode(Swift.type(of: type), forKey: .type)) ?? .link
        tags = (try? container.decode(Swift.type(of: tags), forKey: .tags)) ?? []
        reminder = try? container.decode(Swift.type(of: reminder), forKey: .reminder)
        highlights = (try? container.decode(Swift.type(of: highlights), forKey: .highlights)) ?? []
        created = (try? container.decode(Swift.type(of: created), forKey: .created)) ?? .init()
        lastUpdate = (try? container.decode(Swift.type(of: lastUpdate), forKey: .lastUpdate)) ?? .init()
        creatorRef = try? container.decode(Swift.type(of: creatorRef), forKey: .creatorRef)
        important = (try? container.decode(Swift.type(of: important), forKey: .important)) ?? false
        broken = (try? container.decode(Swift.type(of: broken), forKey: .broken)) ?? false
        duplicate = try? container.decode(Swift.type(of: duplicate), forKey: .duplicate)
        file = try? container.decode(Swift.type(of: file), forKey: .file)
        pleaseParse = try? container.decode(Swift.type(of: pleaseParse), forKey: .pleaseParse)
        cache = try? container.decode(Swift.type(of: cache), forKey: .cache)
                
        if let collectionContainer = try? container.nestedContainer(keyedBy: MongoRef<Int>.CodingKeys.self, forKey: .collection) {
            collection = try collectionContainer.decode(Swift.type(of: collection), forKey: .id)
        } else {
            collection = -1
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        try encode(to: encoder, configuration: .all)
    }
    
    public func encode(to encoder: Encoder, configuration: EncodeConfiguration) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        //all
        if case .all = configuration {
            try container.encode(id, forKey: ._id)
            try container.encode(creatorRef, forKey: .creatorRef)
            try container.encode(broken, forKey: .broken)
            try container.encode(duplicate, forKey: .duplicate)
            try container.encode(file, forKey: .file)
            try container.encode(cache, forKey: .cache)
            try container.encode(domain, forKey: .domain)
        }
        
        //all or new
        switch configuration {
        case .all, .new:
            try container.encodeIfPresent(created, forKey: .created)
            try container.encodeIfPresent(lastUpdate, forKey: .lastUpdate)
        default: break
        }
        
        //new or modified
        var compare: Raindrop?
        if case .modified(let from) = configuration {
            compare = from
        }
        
        if compare?.title != title {
            try container.encode(title, forKey: .title)
        }
        
        if compare?.excerpt != excerpt {
            try container.encode(excerpt, forKey: .excerpt)
        }
        
        if compare?.link != link {
            try container.encode(link, forKey: .link)
        }
        
        if compare?.cover != cover {
            if cover?.host == Rest.base.render.host {
                try container.encode("<screenshot>", forKey: .cover)
            } else {
                try container.encode(cover, forKey: .cover)
            }
        }
        
        if compare?.media != media {
            try container.encode(media, forKey: .media)
        }
        
        if compare?.type != type {
            try container.encode(type, forKey: .type)
        }
        
        if compare?.tags != tags {
            try container.encode(tags, forKey: .tags)
        }
        
        if compare?.reminder != reminder {
            try container.encode(reminder, forKey: .reminder)
        }
        
        if compare?.highlights != highlights {
            //TODO: send only changed for .modified configuration
            try container.encode(highlights, forKey: .highlights)
        }

        if compare?.important != important {
            try container.encode(important, forKey: .important)
        }
        
        if compare?.collection != collection {
            try container.encode(MongoRef<Int>(collection), forKey: .collection)
        }
        
        if compare?.pleaseParse != pleaseParse {
            try container.encode(pleaseParse, forKey: .pleaseParse)
        }
        
        if compare?.order != order {
            try container.encode(order, forKey: .order)
        }
    }
}
