import SwiftUI

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        //hex color #ffffff
        let hexString = try? container.decode(String.self)
        if let hexString, let color = Self(hexString: hexString) {
            self = color
            return
        }
        
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "only support color hex at the moment"
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        if let hexString {
            var container = encoder.singleValueContainer()
            try container.encode(hexString)
        }
    }
}
