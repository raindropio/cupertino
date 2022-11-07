import SwiftUI

extension Raindrop {
    public struct Cover: Codable, Equatable, Hashable {
        public var original: URL?
        public var best: URL?
        
        public init(_ url: URL? = nil) {
            self.original = url
            if let url {
                self.best = Render.asImageUrl(url, options: .maxDeviceSize)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.init(try? container.decode(URL.self))
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(original)
        }
    }
}
