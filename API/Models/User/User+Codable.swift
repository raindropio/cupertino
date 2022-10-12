import Foundation

extension User: Codable {
    //variables that should be in json of API
    enum CodingKeys: String, CodingKey {
        case _id
        case name
        case email
        case avatar
        case pro
        case registered
        case password
        case files
        
        case apple, google, facebook, twitter, vkontakte
        case dropbox, gdrive
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(type(of: id), forKey: ._id)
        name = try container.decode(type(of: name), forKey: .name)
        email = (try? container.decode(type(of: email), forKey: .email)) ?? ""
        avatar = try? container.decode(type(of: avatar), forKey: .avatar)
        pro = (try? container.decode(type(of: pro), forKey: .pro)) ?? false
        registered = try container.decode(type(of: registered), forKey: .registered)
        password = (try? container.decode(type(of: password), forKey: .password)) ?? false
        files = try container.decode(type(of: files), forKey: .files)
        
        apple = (try? container.decode(type(of: apple), forKey: .apple)) ?? Connect()
        google = (try? container.decode(type(of: google), forKey: .google)) ?? Connect()
        facebook = (try? container.decode(type(of: facebook), forKey: .facebook)) ?? Connect()
        twitter = (try? container.decode(type(of: twitter), forKey: .twitter)) ?? Connect()
        vkontakte = (try? container.decode(type(of: vkontakte), forKey: .vkontakte)) ?? Connect()
        dropbox = (try? container.decode(type(of: dropbox), forKey: .dropbox)) ?? Connect()
        gdrive = (try? container.decode(type(of: gdrive), forKey: .gdrive)) ?? Connect()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(pro, forKey: .pro)
        try container.encode(registered, forKey: .registered)
        try container.encode(password, forKey: .password)
        try container.encode(files, forKey: .files)
        
        try container.encode(apple, forKey: .apple)
        try container.encode(google, forKey: .google)
        try container.encode(facebook, forKey: .facebook)
        try container.encode(twitter, forKey: .twitter)
        try container.encode(vkontakte, forKey: .vkontakte)
        try container.encode(dropbox, forKey: .dropbox)
        try container.encode(gdrive, forKey: .gdrive)
    }
}
