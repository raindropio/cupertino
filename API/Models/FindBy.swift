import Foundation

public struct FindBy: Equatable, Hashable, Codable {
    public var collectionId: Collection.ID = 0
    public var filters = [Filter]()
    public var text: String = ""
    
    private init(
        _ collectionId: Collection.ID = 0,
        filters: [Filter] = [],
        text: String = ""
    ) {
        self.collectionId = collectionId
        self.filters = filters
        self.text = text
    }
    
    public init() {}
    
    public init(_ collection: Collection) {
        self.collectionId = collection.id
    }
    
    public init(_ filter: Filter) {
        self.filters = [filter]
    }
}

extension FindBy {
    var search: String {
        (filters.map{ $0.description } + [text]).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
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

//Ability to concat multiple queries
extension FindBy {
    public static func +(lhs: Self, rhs: Collection.ID?) -> Self {
        if let rhs {
            return .init(rhs, filters: lhs.filters, text: lhs.text)
        } else {
            return lhs
        }
    }
    
    public static func +(lhs: Self, rhs: [Filter]) -> Self {
        .init(lhs.collectionId, filters: lhs.filters+rhs, text: lhs.text)
    }
    
    public static func +(lhs: Self, rhs: String) -> Self {
        .init(lhs.collectionId, filters: lhs.filters, text: "\(lhs.text) \(rhs)".trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
