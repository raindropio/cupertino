import Foundation

public class CachedDefaultsStorage {
    public static var version = 1
    public static var defaults = UserDefaults.standard
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    static let prefix = "cached-\(version)-"
    
    static func load<T: Decodable>(_ cacheKey: String) -> T? {
        //get from defaults
        if let data = defaults.object(forKey: "\(prefix)-\(cacheKey)") as? Data {
            if let decoded = try? decoder.decode(T.self, from: data) {
                return decoded
            }
        }
        
        return nil
    }
    
    static func save<T: Encodable>(_ cacheKey: String, value: T?) {
        if value == nil {
            defaults.removeObject(forKey: "\(prefix)-\(cacheKey)")
        }
        else if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: "\(prefix)-\(cacheKey)")
        }
    }
}
