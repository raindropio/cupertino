import Foundation

extension Rest {
    struct ItemsRequest<Item: EncodableWithConfiguration>: EncodableWithConfiguration {
        var items: [Item]
        
        enum CodingKeys: String, CodingKey {
            case items
        }
        
        public func encode(to encoder: Encoder, configuration: Item.EncodingConfiguration) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(items, forKey: .items, configuration: configuration)
        }
    }
}
