import SwiftUI

public enum RaindropType: String, Codable, CaseIterable {
    case link, article, book, document, image, audio, video
    
    public var title: String {
        switch self {
        case .link: return "Links"
        case .article: return "Articles"
        case .image: return "Images"
        case .video: return "Video"
        case .audio: return "Audio"
        case .document: return "Documents"
        case .book: return "Books"
        }
    }
    
    public var single: String {
        switch self {
        case .link: return "Link"
        case .article: return "Article"
        case .image: return "Image"
        case .video: return "Video"
        case .audio: return "Audio"
        case .document: return "Document"
        case .book: return "Book"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .link: return "link"
        case .article: return "square.text.square"
        case .image: return "photo"
        case .audio: return "music.note"
        case .video: return "play.square"
        case .document: return "doc.text"
        case .book: return "book"
        }
    }
    
    public var color: Color { switch self {
        case .link: return .gray
        case .article: return .orange
        case .image: return .green
        case .video: return .purple
        case .document: return .mint
        case .audio: return .indigo
        case .book: return .brown
    }}
}

extension RaindropType: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self = Self.allCases.first {
            String(describing: $0) == value
        } ?? .link
    }
}
