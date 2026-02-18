import Foundation

public enum UpdateRaindropsRequest {
    case moveTo(Int)
    case addTags([String])
    case deleteTags([String])
    case removeTags
    case important(Bool)
}

extension UpdateRaindropsRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case collection
        case addTags
        case deleteTags
        case tags
        case important
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .moveTo(let collection):
            try container.encode(MongoRef<Int>(collection), forKey: .collection)

        case .addTags(let tags):
            try container.encode(tags, forKey: .addTags)

        case .deleteTags(let tags):
            try container.encode(tags, forKey: .deleteTags)

        case .removeTags:
            try container.encode([String](), forKey: .tags)

        case .important(let important):
            try container.encode(important, forKey: .important)
        }
    }
}
