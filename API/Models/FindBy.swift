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
    
    public func scope(_ otherCollectionId: Collection.ID?) -> Self {
        if let otherCollectionId {
            return .init(otherCollectionId, filters: filters, text: text)
        } else {
            return self
        }
    }
}

extension FindBy {
    var search: String {
        (filters.map{ $0.description } + [text]).joined(separator: " ")
    }
}

extension FindBy {
    var query: [URLQueryItem] {
        [.init(name: "search", value: search)]
        + (search.isEmpty ? [] : [.init(name: "nested", value: "true")])
    }
}

//Ability to concat multiple queries
extension FindBy {
    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(rhs.collectionId, filters: lhs.filters + rhs.filters, text: "\(lhs.text) \(rhs.text)")
    }
    
    public static func +(lhs: Self, rhs: Filter) -> Self {
        .init(lhs.collectionId, filters: lhs.filters+[rhs], text: lhs.text)
    }
    
    public static func +(lhs: Self, rhs: String) -> Self {
        .init(lhs.collectionId, filters: lhs.filters, text: "\(lhs.text) \(rhs)")
    }
}
