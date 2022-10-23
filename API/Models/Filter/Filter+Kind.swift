import SwiftUI

//TODO: ExpressibleByStringLiteral
extension Filter {
    public enum Kind: CustomStringConvertible, Equatable, Hashable, Codable {
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
            case .important: return "important:true"
            case .type(let type): return "type:\(type.rawValue)"
            case .created(let date): return "created:\(date)"
            case .highlights: return "highlights:true"
            case .broken: return "broken:true"
            case .duplicate: return "duplicate:true"
            case .notag: return "notag:true"
            case .file: return "file:true"
            case .tag(let tag): return tag.contains(" ") ? "\"#\(tag)\"" : "#\(tag)"
            }
        }
        
        public var title: String {
            switch self {
            case .important: return "Favorites"
            case .type(let type): return type.title
            case .created(let date): return CreatedDateFormatter.format(date)
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
            case .notag: return "circlebadge.2"
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

fileprivate final class CreatedDateFormatter {
    private static var cache = [String: String]()
    
    static func format(_ string: String) -> String {
        if cache[string] == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            
            cache[string] = formatter.date(from: string)?
                .formatted(
                    .dateTime.month(.wide).year()
                )
        }
        
        return cache[string] ?? ""
    }
}
