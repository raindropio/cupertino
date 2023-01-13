import Foundation

public enum SortBy: Hashable, Codable {
    case score
    case sort
    case created(Order = .desc)
    case title(Order = .asc)
    
    public var title: String {
        switch self {
        case .score: return "Best matches"
        case .sort: return "Manually"
        case .created(let order): return order == .desc ? "New first" : "Old first"
        case .title(let order): return order == .desc ? "Title (Z to A)" : "Title (A to Z)"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .score: return "text.magnifyingglass"
        case .sort: return "arrow.up.arrow.down"
        case .created(let order): return order == .desc ? "clock" : "clock.arrow.circlepath"
        case .title(let order): return order == .desc ? "textformat.size" : "textformat"
        }
    }
}

extension SortBy {
    public enum Order: Codable {
        case asc
        case desc
    }
}

extension SortBy: CaseIterable {
    public static var allCases: [SortBy] {
        [
            .score,
            .sort,
            .created(.desc),
            .created(.asc),
            .title(.asc),
            .title(.desc)
        ]
    }
    
    public static func someCases(for findBy: FindBy) -> [SortBy] {
        var cases: [SortBy] = (
            findBy.search.isEmpty ?
                findBy.collectionId != 0 ? [.sort] : []
                : [.score]
        )
        + [
            .created(.desc),
            .created(.asc),
            .title(.asc),
            .title(.desc),
        ]
        
        //score is bad for non text search
        if findBy.isSearching, findBy.text.isEmpty {
            cases.move(fromOffsets: [1], toOffset: 0)
        }
        
        return cases
    }
}

extension SortBy: CustomStringConvertible {
    public var description: String {
        switch self {
            case .sort: return "-sort"
            case .score: return "score"
            case .created(let order): return "\(order == .desc ? "-": "")created"
            case .title(let order): return "\(order == .desc ? "-" : "")title"
        }
    }
}

extension SortBy: Identifiable {
    public var id: String { description }
}
