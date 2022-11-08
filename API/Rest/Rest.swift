import Foundation

public actor Rest: FetchDelegate {
    static let base = URL(string: "https://api.raindrop.io/v1/")!
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(JSISO8601DateFormatter.decodedDate)
        return decoder
    }()
    
    let encoder: JSONEncoder = {
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .custom(JSISO8601DateFormatter.encodeDate)
        return decoder
    }()
    
    let fetch = Fetch(base)
    
    public init() {
        fetch.setDelegate(self)
    }
}
