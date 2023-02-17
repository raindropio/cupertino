public struct RaindropSuggestions: Equatable {
    public var collections: [UserCollection.ID] = []
    public var tags: [String] = []
}

extension RaindropSuggestions: Codable {
    enum CodingKeys: String, CodingKey {
        case collections
        case tags
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        collections = (try? container.decode(Array<MongoRef<UserCollection.ID>>.self, forKey: .collections))?.compactMap { $0.id } ?? []
        tags = (try? container.decode(type(of: tags), forKey: .tags)) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(collections.map { MongoRef<UserCollection.ID>($0) }, forKey: .collections)
        try container.encode(tags, forKey: .tags)
    }
}
