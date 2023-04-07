import Foundation

extension Raindrop {
    public struct Media: Codable, Equatable, Hashable {
        var type = "image"
        public var link: URL?
        
        public init(_ link: URL) {
            self.link = link
        }
    }
}
