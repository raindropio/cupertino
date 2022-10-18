import SwiftUI

extension Raindrop {
    public struct Cover: Codable, Equatable, Hashable {
        public var original: URL?
        public var best: URL?
        
        public init(_ url: URL) {
            self.original = url
            self.best = Render.asImageUrl(url, options: .maxDeviceSize)
        }
    }
}
