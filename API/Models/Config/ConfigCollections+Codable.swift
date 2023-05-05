import Foundation

extension ConfigCollections: Codable {
    enum CodingKeys: CodingKey {
        case default_collection_view
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        defaultView = (try? container.decode(CollectionView.self, forKey: .default_collection_view)) ?? .list
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(defaultView, forKey: .default_collection_view)
    }
}
