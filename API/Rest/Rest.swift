import Foundation

public actor Rest: FetchDelegate {
    static let base = Base()
    
    struct Base {
        var api = URL(string: "https://api.raindrop.io/v1/")!
        var preview = URL(string: "https://preview.systems/")!
        var render = URL(string: "https://rdl.ink/")!
    }
    
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
    
    let fetch = Fetch(base.api)
    
    public init() {
        fetch.setDelegate(self)
    }
}
