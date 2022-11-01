import Foundation

//MARK: - Get many
extension Rest {
    public func collectionsGet() async throws -> ([SystemCollection], [UserCollection]) {
        async let fetchSystem: CollectionsResponse<SystemCollection> = fetch.get("user/stats")
        async let fetchAll: CollectionsResponse<UserCollection> = fetch.get("collections/all")
        let (system, all) = try await (fetchSystem, fetchAll)
        return (system.items, all.items)
    }
    
    fileprivate struct CollectionsResponse<C: CollectionProtocol>: Decodable {
        var items: [C]
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

//MARK: - Update collection
extension Rest {
    public func collectionUpdate(original: UserCollection, changed: UserCollection) async throws -> UserCollection {
        let res: CollectionUpdateResponse = try await fetch.put(
            "collection/\(original.id)",
            body: changed,
            configuration: .changed(from: original)
        )
        return res.item
    }
    
    fileprivate struct CollectionUpdateResponse: Decodable {
        var item: UserCollection
    }
}
