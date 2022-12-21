import Foundation

extension Subscription {
    public struct Links: Codable, Equatable {
        public var manage: URL?
        public var payments: URL?
    }
}
