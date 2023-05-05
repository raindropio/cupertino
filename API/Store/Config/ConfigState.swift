import Foundation

public struct ConfigState: ReduxState {
    public init() {}
    
    @Persisted("cfg-collections") public var collections = ConfigCollections()
    @Persisted("cfg-raindrops") public var raindrops = ConfigRaindrops()
}

extension ConfigState: Codable {
    public init(from decoder: Decoder) throws {
        collections = try .init(from: decoder)
        raindrops = try .init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try collections.encode(to: encoder)
        try raindrops.encode(to: encoder)
    }
}
