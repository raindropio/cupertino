import Foundation

extension CollectionsState {
    public func childrens(of id: UserCollection.ID) -> [UserCollection] {
        if id <= 0 {
            return []
        }
        
        return user
            .filter { $0.value.parent == id }
            .map { $0.value }
            .sorted(using: KeyPathComparator(\.sort))
    }
    
    public func location(of collection: UserCollection) -> [UserCollection] {
        guard
            let parentId = collection.parent,
            let parent = user[parentId]
        else { return [] }
        
        return [parent] + location(of: parent)
    }
    
    public func location(of collection: UserCollection) -> CGroup? {
        let rootId = location(of: collection).last?.id ?? collection.id
                        
        for group in groups {
            if group.collections.contains(rootId) {
                return group
            }
        }
        return nil
    }
    
    public func find(_ search: String) -> [UserCollection] {
        let filter = search.localizedLowercase.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if filter.isEmpty {
            return []
        }
        
        return user
            .filter {
                $0.value.title.localizedLowercase.contains(filter)
            }
            .map {
                $0.value
            }
            .sorted(using: [
                KeyPathComparator(\.parent),
                KeyPathComparator(\.title)
            ])
    }
    
    public var isEmpty: Bool {
        user.isEmpty && !system.contains { $0.1.count > 0 }
    }
    
    public var expandedCount: Int {
        groups.filter { $0.hidden }.count +
        user.filter { $0.value.expanded }.count
    }
}
