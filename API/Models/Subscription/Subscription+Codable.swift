extension Subscription: Codable {
    enum CodingKeys: String, CodingKey {
        case _id
        case status
        case plan
        case renewAt
        case stopAt
        case price
        case links
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(type(of: id), forKey: ._id)) ?? ""
        status = (try? container.decode(type(of: status), forKey: .status)) ?? .unknown
        plan = (try? container.decode(type(of: plan), forKey: .plan)) ?? .unknown
        renewAt = try? container.decode(type(of: renewAt), forKey: .renewAt)
        stopAt = try? container.decode(type(of: stopAt), forKey: .stopAt)
        price = (try? container.decode(type(of: price), forKey: .price)) ?? .init()
        links = (try? container.decode(type(of: links), forKey: .links)) ?? .init()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(status, forKey: .status)
        try container.encode(plan, forKey: .plan)
        try container.encodeIfPresent(renewAt, forKey: .renewAt)
        try container.encodeIfPresent(stopAt, forKey: .stopAt)
        try container.encode(price, forKey: .price)
        try container.encode(links, forKey: .links)
    }
}
