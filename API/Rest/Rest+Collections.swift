import Foundation

//MARK: - Get many
extension Rest {
    public func collectionsGet() async throws -> [Collection] {
        async let fetchAll: CollectionsResponse = fetch.get("collections/all")
        async let fetchSystem: CollectionsResponse = fetch.get("user/stats")
        let (all, system) = try await (fetchAll, fetchSystem)
        return system.items + all.items
    }
    
    fileprivate struct CollectionsResponse: Decodable {
        var items: [Collection]
    }
}

//MARK: - Get groups
extension Rest {
    public func collectionGroupsGet() async throws -> [CGroup] {
        let res: CollectionGroupsResponse = try await fetch.get("user")
        return res.user.groups
    }
    
    fileprivate struct CollectionGroupsResponse: Decodable {
        var user: U
        
        struct U: Decodable {
            var groups: [CGroup]
        }
    }
}
