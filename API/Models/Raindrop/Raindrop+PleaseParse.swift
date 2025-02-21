import Foundation

extension Raindrop {
    public struct PleaseParse: Codable, Equatable, Hashable {
        var weight: Int = 1
        var date: Date? = Date()
        var disableNotification: Bool? = true
    }
}
