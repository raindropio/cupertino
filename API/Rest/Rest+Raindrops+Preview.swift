import Foundation

extension Rest {
    public static func raindropPreview(_ id: Raindrop.ID, options: ReaderOptions = .init()) -> URL {
        var components = URLComponents()
        components.queryItems = options.query
        
        return .init(
            string: "raindrop/preview/\(id)#\(components.query ?? "")",
            relativeTo: base.api
        )!
    }
}
