import Foundation
import UIKit

struct Render {
    static let host = "rdl.ink"
    
    static func asImageUrl(_ url: URL, options: Option...) -> URL {
        guard url.host() != Self.host else { return url }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = Self.host
        components.path = "/render"
        
        components.queryItems =
            Option.format().rawValue
            + Option.dpr().rawValue
            + options.flatMap { $0.rawValue }
            + [.init(name: "url", value: url.absoluteString)]
        
        guard let imageUrl = components.url else { return url }
        return imageUrl
    }
    
    static func asFaviconUrl(_ host: String, options: Option...) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Self.host
        components.path = "/favicon/\(host)"
        
        components.queryItems =
            Option.format().rawValue
            + Option.dpr().rawValue
            + options.flatMap { $0.rawValue }
        
        guard let imageUrl = components.url else { return nil }
        return imageUrl
    }
}
