import API

extension WebHighlights {
    enum Event {
        case unknown
        case ready
        case add(Highlight)
        case update(Updated)
        case remove(Updated)
        
        struct Updated: Decodable {
            var _id: Highlight.ID
            var text: String?
            var note: String?
            var color: Highlight.Color?
            var index: Int?
        }
    }
}

extension WebHighlights.Event: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
        case payload
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(String.self, forKey: .type)
                        
        switch type {
        case "RDH_READY":
            self = .ready
            return
            
        case "RDH_ADD":
            let highlight = try? container.decode(Highlight.self, forKey: .payload)
            if let highlight {
                self = .add(highlight)
                return
            }
            
        case "RDH_UPDATE":
            let updated = try? container.decode(Updated.self, forKey: .payload)
            if let updated {
                self = .update(updated)
                return
            }
            
        case "RDH_REMOVE":
            let updated = try? container.decode(Updated.self, forKey: .payload)
            if let updated {
                self = .remove(updated)
                return
            }
            
        default: break
        }
        
        self = .unknown
        print("uknown web highlight type = \(type)")
    }
}
