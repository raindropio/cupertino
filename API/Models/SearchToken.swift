public enum SearchToken: Identifiable, Equatable, Hashable {
    case filter(Filter)
    case tag(Tag)
    case matchOr
    
    public var id: String {
        switch self {
        case .filter(let filter): return filter.id
        case .tag(let tag): return tag.id
        case .matchOr: return "match:or"
        }
    }
    
    public var title: String {
        switch self {
        case .filter(let filter): return filter.title
        case .tag(let tag): return tag.name
        case .matchOr: return "Match Any"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .filter(let filter): return filter.systemImage
        case .tag(let tag): return tag.systemImage
        case .matchOr: return "arrow.triangle.branch"
        }
    }
}
