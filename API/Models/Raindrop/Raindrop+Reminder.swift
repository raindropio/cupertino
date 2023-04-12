import Foundation

extension Raindrop {
    public struct Reminder: Codable, Equatable, Hashable {
        public var date: Date
        
        public init(_ date: Date) {
            self.date = date
        }
    }
}
