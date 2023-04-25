import Foundation

public struct ConfigState: ReduxState {
    public init() {}
    
    @Persisted("cfg-raindrops") public var raindrops = ConfigRaindrops()
}

extension ConfigState: Codable {
    public init(from decoder: Decoder) throws {
        raindrops = try .init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try raindrops.encode(to: encoder)
    }
}
