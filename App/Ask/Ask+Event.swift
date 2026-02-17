import API

extension Ask {
    enum Event {
        case unknown
        case close
        case toolCalled
        case linkClick(LinkClickDestination)
        
        struct LinkClickDestination: Decodable {
            let raindropId: Int?
            let collectionId: Int?
            let tag: String?
        }
    }
}

extension Ask.Event: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "close":
            self = .close
            return

        case "tool-called":
            self = .toolCalled
            return
            
        case "link-click":
            let item = try LinkClickDestination(from: decoder)
            self = .linkClick(item)
            return

        default: break
        }

        self = .unknown
        print("unknown ask event type = \(type)")
    }
}
