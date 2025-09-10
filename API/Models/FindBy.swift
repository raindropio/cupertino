import Foundation

public struct FindBy: Equatable, Hashable, Codable {
    public var collectionId: Int = 0
    public var filters = [Filter]()
    public var text: String = ""
    
    public init(
        _ collectionId: Int = 0,
        filters: [Filter] = [],
        text: String = ""
    ) {
        self.collectionId = collectionId
        self.filters = filters
        self.text = text
    }
    
    public init() {}
    
    public init(_ collection: SystemCollection) {
        self.collectionId = collection.id
    }
    
    public init(_ collection: UserCollection) {
        self.collectionId = collection.id
    }
    
    public init(_ filter: Filter) {
        self.filters = [filter]
    }
    
    public init(_ text: String) {
        self.text = text
    }
}

extension FindBy {
    var search: String {
        (filters.map{ $0.description } + [text])
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var searchLocalized: String {
        (filters.map{ $0.title } + (text.isEmpty ? [] : ["\"\(text)\""]))
            .joined(separator: ", ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var isSearching: Bool {
        !search.isEmpty
    }
}

extension FindBy {
    var query: [URLQueryItem] {
        [
            .init(name: "search", value: search),
            .init(name: "version", value: "2")
        ]
        + (search.isEmpty ? [] : [.init(name: "nested", value: "true")])
    }
}

extension FindBy {
    public static func +(lhs: Self, rhs: Self) -> Self {
        if lhs == rhs {
            return lhs
        }
        
        return .init(
            rhs.collectionId,
            filters: lhs.filters + rhs.filters, //TODO: uniqnes
            text: "\(lhs.text) \(rhs.text)"
                .trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    public static func +(lhs: Self, rhs: Filter) -> Self {
        var find = lhs
        if !find.filters.contains(where: {
            $0.kind == rhs.kind
        }) {
            find.filters.append(rhs)
        }
        return find
    }
    
    public func excludingText() -> Self {
        var copy = self
        copy.text = ""
        return copy
    }
    
    public func excludingFilters() -> Self {
        var copy = self
        copy.filters = []
        return copy
    }
}
