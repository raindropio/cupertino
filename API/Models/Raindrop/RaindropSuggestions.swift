public struct RaindropSuggestions: Equatable {
    public var collections: [UserCollection.ID] = []
    public var tags: [String] = []
    public var new_tags: [String] = []
}

private struct RaindropSuggestionCollection: Codable {
    var id: UserCollection.ID
    var confidence: Double?
        
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case confidence = "confidence"
    }
}

extension RaindropSuggestions: Codable {
    enum CodingKeys: String, CodingKey {
        case collections
        case tags
        case new_tags
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        collections = (try? container.decode(Array<RaindropSuggestionCollection>.self, forKey: .collections))?.compactMap { $0.id } ?? []
        tags = (try? container.decode(type(of: tags), forKey: .tags)) ?? []
        new_tags = (try? container.decode(type(of: new_tags), forKey: .new_tags)) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(collections.map { RaindropSuggestionCollection(id: $0) }, forKey: .collections)
        try container.encode(tags, forKey: .tags)
        try container.encode(new_tags, forKey: .new_tags)
    }
}
