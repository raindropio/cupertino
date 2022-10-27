import Foundation

extension UserCollection: Codable {
    //variables that should be in json to send to API
    enum CodingKeys: String, CodingKey {
        case _id
        case title
        case description
        case count
        case cover
        case color
        case parent
        case created
        case lastUpdate
        case `public`
        case expanded
        case view
        case sort
        case access
        case collaborators
        case creatorRef
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //as is
        id = try container.decode(type(of: id), forKey: ._id)
        title = try container.decode(type(of: title), forKey: .title)
        description = (try? container.decode(type(of: description), forKey: .description)) ?? ""
        count = (try? container.decode(type(of: count), forKey: .count)) ?? 0
//        color = (try? container.decode(type(of: color), forKey: .color)) ?? nil
        created = try? container.decode(type(of: created), forKey: .created)
        lastUpdate = try? container.decode(type(of: lastUpdate), forKey: .lastUpdate)
        self.public = (try? container.decode(type(of: self.public), forKey: .public)) ?? false
        expanded = (try? container.decode(type(of: expanded), forKey: .expanded)) ?? false
        view = (try? container.decode(type(of: view), forKey: .view)) ?? .list
        sort = (try? container.decode(type(of: sort), forKey: .sort)) ?? 0
        access = (try? container.decode(type(of: access), forKey: .access)) ?? .init()
        creatorRef = try? container.decode(Swift.type(of: creatorRef), forKey: .creatorRef)

        //complicated
        if let coverArray = try? container.decode([URL].self, forKey: .cover), coverArray.count>0 {
            cover = coverArray.first
        } else {
            cover = nil
        }
                
        if let parentContainer = try? container.nestedContainer(keyedBy: MongoRef<UserCollection.ID>.CodingKeys.self, forKey: .parent) {
            parent = try parentContainer.decode(type(of: parent), forKey: .id)
        } else {
            parent = nil
        }
        
        if let collaboratorsContainer = try? container.nestedContainer(keyedBy: MongoRef<String>.CodingKeys.self, forKey: .collaborators) {
            collaborators = try collaboratorsContainer.decode(type(of: collaborators), forKey: .id)
        } else {
            collaborators = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        //as is
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(count, forKey: .count)
        try container.encode(created, forKey: .created)
        try container.encode(lastUpdate, forKey: .lastUpdate)
        try container.encode(self.public, forKey: .public)
        try container.encode(expanded, forKey: .expanded)
        try container.encode(view, forKey: .view)
        try container.encode(sort, forKey: .sort)
        try container.encode(access, forKey: .access)
        try container.encode(creatorRef, forKey: .creatorRef)
        
        //complicated
//        if color != nil {
//            try container.encode(color, forKey: .color)
//        }
        
        if cover != nil {
            try container.encode([cover], forKey: .cover)
        }
        
        if parent != nil {
            try container.encode(MongoRef<UserCollection.ID>(id: parent!), forKey: .parent)
        }
        
        if collaborators != nil {
            try container.encode(MongoRef<String>(id: collaborators!), forKey: .collaborators)
        }
    }
}
