import Foundation
import API

enum SearchToken: Identifiable, Hashable {
    case filter(Filter)
    case tag(Tag)
    case matchOr
    
    var id: String {
        switch self {
        case .filter(let filter): return filter.query
        case .tag(let tag): return tag.query
        case .matchOr: return "match:or"
        }
    }
    
    var label: String {
        switch self {
        case .filter(let filter): return filter.title
        case .tag(let tag): return tag.title
        case .matchOr: return "Match Any"
        }
    }
    
    var systemImage: String {
        "line.3.horizontal.decrease.circle"
    }
}
