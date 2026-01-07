import Foundation

fileprivate let cache = NSCache<NSURL, NSURL>()

extension URL {
    /// Strip everything non-significant like:
    /// - scheme, hash, user, password, www
    /// - sort query parameters
    /// - trailing slash
    var compact: Self {
        if let cached = cache.object(forKey: self as NSURL) {
            return cached as URL
        }

        let components = NSURLComponents.init(url: self, resolvingAgainstBaseURL: true)
        guard let components else { return self }

        //keep hash for SPA
        if components.fragment?.contains("/") == false {
            components.fragment = nil
        }

        components.scheme = nil
        components.user = nil
        components.password = nil
        components.host = (components.host ?? "").replacingOccurrences(of: "www.", with: "")
        components.queryItems = components.queryItems?.sorted(using: [
            KeyPathComparator(\.name),
            KeyPathComparator(\.value)
        ])
        if let path = components.path, path.hasSuffix("/") {
            components.path = String(path.dropLast(1))
        }

        if let url = components.url?.absoluteURL {
            cache.setObject(url as NSURL, forKey: self as NSURL)
            return url
        }

        return self
    }
}
