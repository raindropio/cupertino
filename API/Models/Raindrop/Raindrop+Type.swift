import SwiftUI

extension Raindrop {
    public enum `Type`: String, Codable, CaseIterable {
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
        
        public var color: Color { switch self {
            case .link: return .secondary
            case .article: return .orange
            case .image: return .green
            case .video: return .purple
            case .document: return .brown
            case .audio: return .indigo
        }}
    }
}

extension Raindrop.`Type`: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self = Self.allCases.first {
            String(describing: $0) == value
        } ?? .link
    }
}
