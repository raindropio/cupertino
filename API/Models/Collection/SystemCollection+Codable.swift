import Foundation

extension SystemCollection: Codable {
    enum CodingKeys: String, CodingKey {
        case _id
        case count
        case view
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(type(of: id), forKey: ._id)
        count = (try? container.decode(type(of: count), forKey: .count)) ?? 0
        view = (try? container.decode(type(of: view), forKey: .view)) ?? .list
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(count, forKey: .count)
        try container.encode(view, forKey: .view)
    }
}
