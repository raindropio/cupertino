import Foundation

extension Raindrop {
    public struct File: Codable, Equatable, Hashable {
        var name: String
        var size: Int = 0
        var type: String = "application/octet-stream"
    }
}
