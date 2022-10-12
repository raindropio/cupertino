import Foundation

extension Raindrop {
    public struct Cache: Codable, Equatable, Hashable {
        var size: Int = 0
        var created = Date()
    }
}
