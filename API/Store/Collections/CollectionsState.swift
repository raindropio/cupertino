public struct CollectionsState: Equatable {
    var items = [Collection.ID: Collection]()
    
    public func item(_ id: Collection.ID) -> Collection? {
        items[id]
    }
}
