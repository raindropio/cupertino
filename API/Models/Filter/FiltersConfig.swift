public struct FiltersConfig: Codable, Equatable {
    public var simpleHidden: Bool = false
    public var tagsHidden: Bool = false
    public var tagsSort: TagsSort = .title
    
    enum CodingKeys: String, CodingKey {
        case simpleHidden = "filters_hide"
        case tagsHidden = "tags_hide"
        case tagsSort = "tags_sort"
    }
}

extension FiltersConfig {
    public enum TagsSort: String, Codable {
        case title = "_id"
        case count = "-count"
    }
}
