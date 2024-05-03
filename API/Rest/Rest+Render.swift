import Foundation

extension Rest {
    public static func renderImage(_ url: URL?, options: RenderOption...) -> URL? {
        guard let url else { return nil }
        
        guard url.host != base.render.host else { return url }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = base.render.host
        components.path = "/render"
        
        components.queryItems =
            RenderOption.dpr().rawValue
            + options.flatMap { $0.rawValue }
            + [.init(name: "url", value: url.absoluteString)]
        
        guard let imageUrl = components.url else { return url }
        
        return imageUrl
    }
    
    public static func renderFavicon(_ host: String, options: RenderOption...) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = base.render.host
        components.path = "/favicon/\(host)"
        
        components.queryItems =
            RenderOption.dpr().rawValue
            + options.flatMap { $0.rawValue }
        
        guard let imageUrl = components.url else { return nil }
        return imageUrl
    }
}
