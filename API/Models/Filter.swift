import SwiftUI

public struct Filter {
    public var kind: Kind
    public var count: Int = 0
    
    public init(_ kind: Kind, count: Int = 0) {
        self.kind = kind
        self.count = 0
    }

    public var title: String { kind.title }
    public var systemImage: String { kind.systemImage }
    public var color: Color { kind.color }
}

extension Filter: Identifiable {
    public var id: String { description }
}

extension Filter: CustomStringConvertible {
    public var description: String { "\(kind)" }
}

extension Filter: Equatable {}

extension Filter {
    //TODO: ExpressibleByStringLiteral
    public enum Kind: CustomStringConvertible, Equatable {
        case important
        case type(Raindrop.`Type`)
        case created(String)
        case highlights
        case broken
        case duplicate
        case notag
        case file
        case tag(String)
        
        public var description: String {
            switch self {
            case .type(let type): return "\(self):\(type.rawValue)"
            case .created(let date): return "\(self):\(date)"
            default: return "\(self):true"
            }
        }
        
        public var title: String {
            switch self {
            case .important: return "Favorites"
            case .type(let type): return type.title
            case .created(let date): return "Created \(date)"
            case .highlights: return "Highlights"
            case .broken: return "Broken links"
            case .duplicate: return "Duplicates"
            case .notag: return "Without tags"
            case .file: return "Files"
            case .tag(let tag): return tag
            }
        }
        
        public var systemImage: String {
            switch self {
            case .important: return "heart"
            case .type(let type): return type.systemImage
            case .created(_): return "calendar"
            case .highlights: return "highlighter"
            case .broken: return "exclamationmark.bubble"
            case .duplicate: return "square.on.square"
            case .notag: return "number.square"
            case .file: return "doc"
            case .tag(_): return "number"
            }
        }
        
        public var color: Color {
            switch self {
            case .important: return .red
            case .type(let type): return type.color
            case .created(_): return .secondary
            case .highlights: return .purple
            case .notag: return .secondary
            case .broken: return .pink
            case .duplicate: return .green
            case .file: return .teal
            case .tag: return .secondary
            }
        }
    }
}
