import Foundation

extension ReaderOptions: Codable {
    enum CodingKeys: String, CodingKey {
        case solidBackground
        case theme
        case fontFamily
        case fontSize
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        solidBackground = try container.decode(type(of: solidBackground), forKey: .solidBackground)
        theme = try? container.decode(type(of: theme), forKey: .theme)
        fontFamily = try? container.decode(type(of: fontFamily), forKey: .fontFamily)
        fontSize = try container.decode(type(of: fontSize), forKey: .fontSize)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(solidBackground, forKey: .solidBackground)
        try container.encode(theme, forKey: .theme)
        try container.encode(fontFamily, forKey: .fontFamily)
        try container.encode(fontSize, forKey: .fontSize)
    }
}
