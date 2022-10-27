import Foundation

public struct CollectionAccess: Equatable, Codable, Hashable {
    public var level: Level = .noAccess
    public var draggable: Bool = false
    
    public enum Level: Int, Codable, Comparable {
        case noAccess
        case `public`
        case viewer
        case member
        case owner
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
}
