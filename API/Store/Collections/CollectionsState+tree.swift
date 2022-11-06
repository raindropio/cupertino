extension CollectionsState {
    public func tree(_ group: CGroup) -> [UserCollection] {
        if !group.hidden {
            return group.collections.flatMap {
                if let collection = user[$0] {
                    return [collection] + tree(collection)
                }
                return []
            }
        }
        return []
    }
    
    public func tree(_ parent: UserCollection) -> [UserCollection] {
        if parent.expanded {
            return children(parent).flatMap {
                return [$0] + tree($0)
            }
        }
        return []
    }
    
    public func children(_ collection: UserCollection) -> [UserCollection] {
        user
            .filter { $0.value.parent == collection.id }
            .map { $0.value }
            .sorted(by: { $0.sort < $1.sort })
    }
    
    public func expandable(_ id: UserCollection.ID) -> Bool {
        user.contains {
            $0.value.parent == id
        }
    }
}

extension CollectionsState {
    public func isEmpty() -> Bool {
        user.isEmpty && !system.contains { $0.1.count > 0 }
    }
}
