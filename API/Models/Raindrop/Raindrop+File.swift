import Foundation

extension Raindrop {
    public struct File: Codable, Equatable, Hashable {
        public var name: String
        public var size: Int = 0
        public var type: String = "application/octet-stream"
    }
}
