import Foundation

public struct ConfigRaindrops: Equatable {
    public var hide: [CollectionView: Set<Element>] = [
        .list: .init(),
        .simple: .init(),
        .masonry: .init(),
        .grid: .init()
    ]
    public var coverSize: Int = 2
    public var coverRight = false
}

extension ConfigRaindrops {
    public enum Element: String, CaseIterable {
        case title, excerpt, cover, tags, info
        
        public var title: String {
            switch self {
            case .title: return "Title"
            case .excerpt: return "Description"
            case .cover: return "Thumbnail"
            case .tags: return "Filters"
            case .info: return "Date, domain & type"
            }
        }
    }
}
