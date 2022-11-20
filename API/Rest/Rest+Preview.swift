import Foundation

extension Rest {
    public static func previewEmbed(_ url: URL) -> URL {
        .init(
            string: "embed/\(url.absoluteString.base64 ?? "")",
            relativeTo: base.preview
        )!
    }
}

extension Rest {
    public static func previewArticle(_ url: URL, options: ReaderOptions = .init()) -> URL {
        var components = URLComponents()
        components.queryItems = options.query
        
        return .init(
            string: "article/\(url.absoluteString.base64 ?? "")#\(components.query ?? "")",
            relativeTo: base.preview
        )!
    }
}
