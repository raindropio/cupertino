import Foundation

extension Rest {
    public func raindropsLinks() async throws -> [URL: Raindrop.ID] {
        let text: String? = try await fetch.get("raindrops/links")
        guard let text else { return [:] }
        
        let lines = text.split(whereSeparator: \.isNewline)
        var links: [URL: Raindrop.ID] = [:]
        
        for line in lines {
            let parts = line.components(separatedBy: "</-rl-/>")
            let id = Int(parts[0])
            let url = URL(string: parts[1].removingPercentEncoding ?? "")
            guard let id, let url else { continue }
            links[url] = id
        }
        
        return links
    }
}
