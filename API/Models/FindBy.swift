struct FindBy {
    var collectionId: Collection.ID = 0
    var filters = [Filter]()
    var text: String = ""
    
    private init(
        _ collectionId: Collection.ID = 0,
        filters: [Filter] = [],
        text: String = ""
    ) {
        self.collectionId = collectionId
        self.filters = filters
        self.text = text
    }
    
    init() {}
    
    init(_ collection: Collection) {
        self.collectionId = collection.id
    }
    
    init(_ filter: Filter) {
        self.filters = [filter]
    }
    
    func scope(_ otherCollectionId: Collection.ID?) -> Self {
        if let otherCollectionId {
            return .init(otherCollectionId, filters: filters, text: text)
        } else {
            return self
        }
    }
}

//Ability to concat multiple queries
extension FindBy {
    static func +(lhs: Self, rhs: Self) -> Self {
        .init(rhs.collectionId, filters: lhs.filters + rhs.filters, text: "\(lhs.text) \(rhs.text)")
    }
    
    static func +(lhs: Self, rhs: Filter) -> Self {
        .init(lhs.collectionId, filters: lhs.filters+[rhs], text: lhs.text)
    }
    
    static func +(lhs: Self, rhs: String) -> Self {
        .init(lhs.collectionId, filters: lhs.filters, text: "\(lhs.text) \(rhs)")
    }
}

//Stable ID to use for caching
extension FindBy: Identifiable {
    var id: String {
        "\(collectionId)-\(description)"
    }
}

extension FindBy: Equatable {
}

//TODO: ExpressibleByStringLiteral
//String representation of tokens+text that will be used in `search` API
extension FindBy: CustomStringConvertible {
    var description: String {
        filters.map { $0.description }.joined(separator: " ") + text
    }
}
