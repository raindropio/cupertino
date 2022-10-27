import Foundation

public actor CachedFileStorage {
    public static var version = 2
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    static let prefix = "cached-\(version)-"
    static var cancelables = [String: Task<(), Never>]()
    
    static func load<T: Decodable>(_ cacheKey: String) -> T? {
        guard
            let url = fileUrl(cacheKey),
            let data = FileManager.default.contents(atPath: url.path),
            let decoded = try? decoder.decode(T.self, from: data)
        else { return nil }

        return decoded
    }
    
    static func save<T: Encodable>(_ cacheKey: String, value: T?) {
        guard let url = fileUrl(cacheKey) else { return }
        
        try? FileManager.default.removeItem(at: url)

        if let encoded = try? encoder.encode(value) {
            FileManager.default.createFile(atPath: url.path, contents: encoded, attributes: nil)
        }
    }
    
    /// Debounce save
    static func save<T: Encodable>(_ cacheKey: String, value: T?, debounce: Double) {
        cancelables[cacheKey]?.cancel()
        cancelables[cacheKey] = Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * debounce))
                try Task.checkCancellation()
                save(cacheKey, value: value)
            } catch {}
        }
    }
    
    private static func fileUrl(_ cacheKey: String) -> URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("\(prefix)-\(cacheKey).json", isDirectory: false)
    }
}
