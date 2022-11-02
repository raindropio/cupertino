public struct CollectionsState: ReduxState {
    var status = Status.idle
    @Cached("cos-system") var system = [SystemCollection.ID: SystemCollection]()
    @Cached("cos-user") var user = [UserCollection.ID: UserCollection]()
    
    public init() {}
}

extension CollectionsState {
    //single item
    public func item(_ id: SystemCollection.ID) -> SystemCollection {
        system[id] ?? .init(id: id)
    }
    
    public func item(_ id: UserCollection.ID) -> UserCollection? {
        user[id]
    }
    
    public func title(_ id: Int) -> String {
        let collection: (any CollectionProtocol)? = system[id] ?? user[id]
        return collection?.title ?? ""
    }
    
    public func view(_ id: Int) -> CollectionView {
        let collection: (any CollectionProtocol)? = system[id] ?? user[id]
        return collection?.view ?? .list
    }
    
    //overall
    public func isEmpty() -> Bool {
        user.isEmpty && !system.contains { $0.1.count > 0 }
    }
    
    public func temp() -> [UserCollection] {
        user.map { $0.1 }
    }
}

extension CollectionsState {
    public enum Status: String, Equatable, Codable {
        case idle
        case loading
        case error
    }
}
