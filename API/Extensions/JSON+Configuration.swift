import Foundation

private let configKey = CodingUserInfoKey(rawValue: UUID().uuidString)!

private struct ConfigWrapper<Value> {
    let value: Value
}

extension ConfigWrapper: Decodable where Value: DecodableWithConfiguration {
    init(from decoder: Decoder) throws {
        let config = decoder.userInfo[configKey]! as! Value.DecodingConfiguration
        value = try Value(from: decoder, configuration: config)
    }
}

extension ConfigWrapper: Encodable where Value: EncodableWithConfiguration {
    func encode(to encoder: Encoder) throws {
        let config = encoder.userInfo[configKey]! as! Value.EncodingConfiguration
        try value.encode(to: encoder, configuration: config)
    }
}

extension JSONDecoder {
    public func decode<T>(_ type: T.Type, from data: Data, configuration: T.DecodingConfiguration) throws -> T where T : DecodableWithConfiguration {
        userInfo[configKey] = configuration
        return try decode(ConfigWrapper<T>.self, from: data).value
    }
}

extension JSONEncoder {
    public func encode<T>(_ value: T, configuration: T.EncodingConfiguration) throws -> Data where T : EncodableWithConfiguration {
        userInfo[configKey] = configuration
        return try encode(ConfigWrapper(value: value))
    }
}
