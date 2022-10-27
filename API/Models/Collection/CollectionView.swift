public enum CollectionView: String, Codable, CaseIterable, Identifiable {
    case list, grid, masonry, simple
    
    public var title: String {
        switch self {
        case .list: return "List"
        case .grid: return "Cards"
        case .masonry: return "Masonry"
        case .simple: return "Headlines"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .list: return "list.bullet"
        case .grid: return "square.grid.2x2"
        case .masonry: return "rectangle.3.group"
        case .simple: return "text.justify"
        }
    }
    
    public var id: String {
        self.rawValue
    }
}
