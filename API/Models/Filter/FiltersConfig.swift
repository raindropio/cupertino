public struct FiltersConfig: Codable, Equatable {
    public var simpleHidden: Bool = false
    public var tagsHidden: Bool = false
    public var tagsSort: TagsSort = .title
    
    enum CodingKeys: String, CodingKey {
        case simpleHidden = "filters_hide"
        case tagsHidden = "tags_hide"
        case tagsSort = "tags_sort"
    }
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        simpleHidden = (try? container.decode(type(of: simpleHidden), forKey: .simpleHidden)) ?? false
        tagsHidden = (try? container.decode(type(of: tagsHidden), forKey: .tagsHidden)) ?? false
        tagsSort = (try? container.decode(type(of: tagsSort), forKey: .tagsSort)) ?? .title
    }
}

extension FiltersConfig {
    public enum TagsSort: String, Codable {
        case title = "_id"
        case count = "-count"
    }
}
