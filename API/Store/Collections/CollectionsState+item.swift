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
}
