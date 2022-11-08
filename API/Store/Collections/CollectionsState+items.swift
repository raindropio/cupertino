extension CollectionsState {
    public func tree(of group: CGroup) -> [UserCollection] {
        group.collections.flatMap {
            if let collection = user[$0] {
                return [collection] + tree(from: collection)
            }
            return []
        }
    }
    
    public func tree(from parent: UserCollection) -> [UserCollection] {
        if parent.expanded {
            return childrens(of: parent.id).flatMap {
                return [$0] + tree(from: $0)
            }
        }
        return []
    }
    
    public func childrens(of id: UserCollection.ID) -> [UserCollection] {
        user
            .filter { $0.value.parent == id }
            .map { $0.value }
            .sorted(by: { $0.sort < $1.sort })
    }
    
    public func path(to collection: UserCollection) -> [UserCollection] {
        guard
            let parentId = collection.parent,
            let parent = user[parentId]
        else { return [] }
        
        return [parent] + path(to: parent)
    }
    
    public func path(to collection: UserCollection) -> CGroup? {
        let rootId = path(to: collection).last?.id ?? collection.id
                        
        for group in groups {
            if group.collections.contains(rootId) {
                return group
            }
        }
        return nil
    }
    
    public func expandable(_ id: UserCollection.ID) -> Bool {
        user.contains {
            $0.value.parent == id
        }
    }
}

extension CollectionsState {
    public var isEmpty: Bool {
        user.isEmpty && !system.contains { $0.1.count > 0 }
    }
    
    public var expandedCount: Int {
        groups.filter { $0.hidden }.count +
        user.filter { $0.value.expanded }.count
    }
}

extension CollectionsState {
    mutating func removeFromGroups(_ id: UserCollection.ID) {
        groups = groups.map {
            var group = $0
            group.collections = group.collections.filter { $0 != id }
            return group
        }
    }
    
    //set correct `sort` value for siblings
    mutating func fixSiblings(of collection: UserCollection) {
        if let parent = collection.parent {
            let siblings = childrens(of: parent).filter { $0.id != collection.id }
            for (i, sibling) in siblings.enumerated() {
                user[sibling.id]?.sort = i >= collection.sort ? i + 1 : i
            }
        }
    }
}
