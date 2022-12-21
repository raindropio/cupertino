extension Highlight: Codable {
    enum CodingKeys: String, CodingKey {
        case _id
        case text
        case note
        case created
        case color
        case creatorRef
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(type(of: id), forKey: ._id)) ?? ""
        text = try container.decodeIfPresent(type(of: text), forKey: .text) ?? ""
        note = try container.decodeIfPresent(type(of: note), forKey: .note) ?? ""
        created = (try? container.decode(type(of: created), forKey: .created)) ?? .init()
        color = (try? container.decode(type(of: color), forKey: .color)) ?? .yellow
        creatorRef = try? container.decode(type(of: creatorRef), forKey: .creatorRef)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(text, forKey: .text)
        try container.encode(note, forKey: .note)
        try container.encode(created, forKey: .created)
        try container.encode(color, forKey: .color)
        try container.encodeIfPresent(creatorRef, forKey: .creatorRef)
    }
}
