import Foundation

fileprivate var cache: [URL: URL] = [:]
fileprivate let queue = DispatchQueue(label: "url-compact-cache", attributes: .concurrent)

extension URL {
    /// Strip everything non-significant like:
    /// - scheme, hash, user, password, www
    /// - sort query parameters
    /// - trailing slash
    var compact: Self {
        var cached: URL?
        queue.sync { cached = cache[self] }
        if let cached { return cached }
        
        let components = NSURLComponents.init(url: self, resolvingAgainstBaseURL: true)
        guard let components else { return self }
        
        components.scheme = nil
        components.fragment = nil
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
            queue.async(flags: .barrier) {
                cache[self] = url
            }
            return url
        }
        
        return self
    }
}
