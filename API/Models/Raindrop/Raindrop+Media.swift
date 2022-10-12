import Foundation

extension Raindrop {
    public struct Media: Codable, Equatable, Hashable {
        var type = "image"
        var link: Cover?
    }
}
