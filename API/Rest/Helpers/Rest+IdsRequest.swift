import Foundation

extension Rest {
    struct IdsRequest<ID: Encodable>: Encodable {
        var ids: [ID]
    }
}

extension Rest {
    struct IdsCombineRequest<ID: Encodable, C: Encodable>: Encodable {
        var ids: [ID]
        var combine: C
        
        enum CodingKeys: String, CodingKey {
            case ids
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try combine.encode(to: encoder)
            try container.encode(ids, forKey: .ids)
        }
    }
}
