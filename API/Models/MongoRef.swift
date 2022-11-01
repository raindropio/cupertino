import Foundation

struct MongoRef<T: Codable>: Codable {
    var id: T
    
    init(_ id: T) {
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
    }
}
