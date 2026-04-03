import SwiftUI

public enum RaindropType: String, Codable, CaseIterable {
    case link, article, book, document, image, audio, video
    
    public var title: String {
        switch self {
        case .link: return String(localized: "Links")
        case .article: return String(localized: "Articles")
        case .image: return String(localized: "Images")
        case .video: return String(localized: "Video")
        case .audio: return String(localized: "Audio")
        case .document: return String(localized: "Documents")
        case .book: return String(localized: "Books")
        }
    }

    public var single: String {
        switch self {
        case .link: return String(localized: "Link")
        case .article: return String(localized: "Article")
        case .image: return String(localized: "Image")
        case .video: return String(localized: "Video")
        case .audio: return String(localized: "Audio")
        case .document: return String(localized: "Document")
        case .book: return String(localized: "Book")
        }
    }
    
    public var systemImage: String {
        switch self {
        case .link: return "link"
        case .article: return "doc.plaintext"
        case .image: return "photo"
        case .audio: return "music.note"
        case .video: return "play"
        case .document: return "doc"
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
    
    public var readable: Bool { switch self {
        case .link: return false
        case .article: return true
        case .image: return true
        case .video: return true
        case .document: return true
        case .audio: return true
        case .book: return true
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
