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
            case .noAccess: return String(localized: "No access")
            case .public: return String(localized: "Viewer")
            case .viewer: return String(localized: "Viewer")
            case .member: return String(localized: "Editor")
            case .owner: return String(localized: "Owner")
            }
        }
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
}
