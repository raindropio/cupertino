import Foundation

public struct WebRequest: Hashable {
    public var url: URL
    public var canonical: URL?
    public var caching: URLRequest.CachePolicy
    public var attribute: AnyHashable?
    
    public init(
        _ url: URL,
        canonical: URL? = nil,
        caching: URLRequest.CachePolicy = .useProtocolCachePolicy,
        attribute: AnyHashable? = nil
    ) {
        self.url = url
        self.canonical = canonical
        self.caching = caching
        self.attribute = attribute
    }
    
    var urlRequest: URLRequest {
        .init(url: url, cachePolicy: caching)
    }
}
