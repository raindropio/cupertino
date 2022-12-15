import SwiftUI

extension Raindrop {
    public struct Highlight: Identifiable, Equatable, Hashable {
        public var id: String
        public var text: String
        public var note: String = ""
        public var created = Date()
        public var color: HighlightColor = .yellow
        public var creatorRef: CreatorRef?
    }
    
    public enum HighlightColor: String, Codable {
        case blue, brown, cyan, gray, green, indigo, orange, pink, purple, red, teal, yellow
        
        public static let bestCases: [Self] = [.yellow, .blue, .green, .red]
        
        public var ui: Color {
            switch self {
            case .blue: return .blue
            case .brown: return .brown
            case .cyan: return .cyan
            case .gray: return .gray
            case .green: return .green
            case .indigo: return .indigo
            case .orange: return .orange
            case .pink: return .pink
            case .purple: return .purple
            case .red: return .red
            case .teal: return .teal
            case .yellow: return .yellow
            }
        }
    }
}

extension Raindrop.Highlight: Codable {
    enum CodingKeys: String, CodingKey {
        case _id
        case text
        case note
        case created
        case color
        case creatorRef
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(type(of: text), forKey: ._id)) ?? ""
        text = try container.decodeIfPresent(type(of: text), forKey: .text) ?? ""
        note = try container.decodeIfPresent(type(of: note), forKey: .note) ?? ""
        created = (try? container.decode(type(of: created), forKey: .created)) ?? .init()
        color = (try? container.decode(type(of: color), forKey: .color)) ?? .yellow
        creatorRef = try? container.decode(type(of: creatorRef), forKey: .creatorRef)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(text, forKey: .text)
        try container.encode(note, forKey: .note)
        try container.encode(created, forKey: .created)
        try container.encode(color, forKey: .color)
        try container.encodeIfPresent(creatorRef, forKey: .creatorRef)
    }
}
