public enum Filter: Identifiable, Hashable {
    case important
    case type(RaindropType)
    case created(String)
    case highlights
    case broken
    case duplicate
    case notag
    case file
    
    public var id: String {
        switch self {
        case .type(let type): return "type:\(type.rawValue)"
        case .created(let date): return "created:\(date)"
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
        }
    }
}

//MARK: Type
public extension Filter {
    enum RaindropType: String {
        case link, article, image, video, audio, document
        
        public var title: String {
            switch self {
            case .link: return "Links"
            case .article: return "Articles"
            case .image: return "Images"
            case .video: return "Video"
            case .audio: return "Audio"
            case .document: return "Documents"
            }
        }
        
        public var systemImage: String {
            switch self {
            case .link: return "link"
            case .article: return "square.text.square"
            case .image: return "photo"
            case .audio: return "music.note"
            case .video: return "play.circle"
            case .document: return "doc"
            }
        }
    }
}

//MARK: - Preview
public extension Filter {
    static var preview = [
        Filter.important,
        Filter.type(.article),
        Filter.type(.image),
        Filter.highlights
    ]
}
