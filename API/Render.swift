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

extension Render {
    enum Option: RawRepresentable {
        case format(Format = .avif)
        case dpr(CGFloat = UIScreen.main.scale)
        case maxDeviceSize
        case width(CGFloat)
        case height(CGFloat)

        init?(rawValue: [URLQueryItem]) {
            nil
        }
        
        var rawValue: [URLQueryItem] {
            switch self {
            case .format(let format):
                return [
                    .init(name: "format", value: "\(format)"),
                ]
                
            case .dpr(let dpr):
                return [
                    .init(name: "dpr", value: "\(Int(dpr))"),
                ]
                
            case .maxDeviceSize:
                let maxSize = Int(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height))

                return [
                    .init(name: "width", value: "\(maxSize)"),
                    .init(name: "height", value: "\(maxSize)"),
                ]
                
            case .width(let width):
                return [
                    .init(name: "width", value: "\(Int(width))")
                ]
                
            case .height(let height):
                return [
                    .init(name: "height", value: "\(Int(height))")
                ]
            }
        }
        
        typealias RawValue = [URLQueryItem]
    }
    
    enum Format: String {
        case avif
    }
}
