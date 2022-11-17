import Foundation

public struct PreviewSystems {
    static let host = "preview.systems"
    
    static func base64(_ url: URL) -> String {
        let data = url.absoluteString.data(using: .utf8)
        return data?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
    }

    public static func embedUrl(_ url: URL) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Self.host
        components.path = "/embed/\(base64(url))"
        
        return components.url!
    }
    
    public static func articleUrl(_ url: URL, options: Options = .init()) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Self.host
        components.path = "/article/\(base64(url))"
        
        components.queryItems = options.query
        components.fragment = components.query
        components.queryItems = .init()
        
        return components.url!
    }
}
