import Foundation

struct MongoRef<T: Encodable>: Encodable {
    var id: T
    enum CodingKeys: String, CodingKey { case id = "$id" }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .init(rawValue: "$id")!)
    }
}
