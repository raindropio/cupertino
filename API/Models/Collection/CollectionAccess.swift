import Foundation

public struct CollectionAccess: Equatable, Codable, Hashable {
    public var level: Level = .noAccess
    public var draggable: Bool = false
}

extension CollectionAccess {
    public enum Level: Int, Codable, Comparable {
        case noAccess
        case `public`
        case viewer
        case member
        case owner
        
        public var title: String {
            switch self {
            case .noAccess: return "No access"
            case .public: return "Read only"
            case .viewer: return "Read only"
            case .member: return "Can edit & invite"
            case .owner: return "Owner"
            }
        }
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
}
