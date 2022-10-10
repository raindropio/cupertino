import SwiftUI

extension Raindrop {
    public struct Cover: ExpressibleByStringLiteral, CustomStringConvertible, Codable, Equatable, Hashable {
        public var original: URL?
        public var best: URL?
        
        public init(_ url: URL) {
            self.original = url
            self.best = Render.asImageUrl(url, options: .maxDeviceSize)
        }
        
        public init(stringLiteral value: String) {
            if let url = URL(string: value) {
                self = .init(url)
            }
        }
        
        public var description: String {
            original?.absoluteString ?? ""
        }
    }
}
