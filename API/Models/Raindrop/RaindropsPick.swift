import Foundation

public enum RaindropsPick: Equatable {
    case all(FindBy)
    case some(Set<Raindrop.ID>)
    
    public var title: String {
        switch self {
        case .all(_): return "All items"
        case .some(let ids): return "\(ids.count) items"
        }
    }
    
    public var isAll: Bool {
        switch self {
        case .all(_): return true
        case .some(_): return false
        }
    }
    
    public var isEmpty: Bool {
        switch self {
        case .all(_): return false
        case .some(let ids): return ids.isEmpty
        }
    }
}

extension RaindropsPick: Identifiable {
    public var id: String {
        switch self {
        case .all(let find): return "\(find.collectionId)\(find.search)"
        case .some(let ids): return "\(ids)"
        }
    }
}
