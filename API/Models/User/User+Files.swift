import Foundation

extension User {
    public struct Files: Equatable, Codable, Hashable {
        var used: Int = 0
        var size: Int = 0
    }
}
