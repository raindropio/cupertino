extension CollectionsState {
    public func title(_ id: Int) -> String {
        let collection: (any CollectionType)? = system[id] ?? user[id]
        return collection?.title ?? ""
    }
    
    public func view(_ id: Int) -> CollectionView {
        let collection: (any CollectionType)? = system[id] ?? user[id]
        return collection?.view ?? .list
    }
}
