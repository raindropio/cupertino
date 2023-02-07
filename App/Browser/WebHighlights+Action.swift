import API

extension WebHighlights {
    enum Action {
        case config(Config)
        case apply([Highlight])
        case scrollTo(Highlight.ID)
        
        struct Config: Encodable {
            var enabled: Bool = true
            var nav: Bool = true
            var pro: Bool = false
        }
    }
}

extension WebHighlights.Action: Encodable {
    enum CodingKeys: String, CodingKey {
        case type
        case payload
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .config(let config):
            try container.encode("RDH_CONFIG", forKey: .type)
            try container.encode(config, forKey: .payload)
            
        case .apply(let highlights):
            try container.encode("RDH_APPLY", forKey: .type)
            try container.encode(highlights, forKey: .payload)
            
        case .scrollTo(let id):
            try container.encode("RDH_SCROLL", forKey: .type)
            try container.encode(id, forKey: .payload)
        }
    }
}
