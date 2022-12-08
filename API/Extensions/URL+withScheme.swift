import Foundation

extension URL {
    func withScheme(_ value: String = "https") -> Self {
        let components = NSURLComponents.init(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = value
        return components?.url ?? self
    }
}
