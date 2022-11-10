import Foundation

extension CGroup: Codable {
    //variables that should be in json of API
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case hidden
        case collections
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(type(of: title), forKey: .title)
        hidden = (try? container.decode(type(of: hidden), forKey: .hidden)) ?? false
        collections = try container.decode(type(of: collections), forKey: .collections)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(hidden, forKey: .hidden)
        try container.encode(collections, forKey: .collections)
    }
}
