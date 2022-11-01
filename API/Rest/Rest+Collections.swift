import Foundation

//MARK: - Get many
extension Rest {
    public func collectionsGet() async throws -> ([SystemCollection], [UserCollection]) {
        async let fetchSystem: ItemsResponse<SystemCollection> = fetch.get("user/stats")
        async let fetchAll: ItemsResponse<UserCollection> = fetch.get("collections/all")
        let (system, all) = try await (fetchSystem, fetchAll)
        return (system.items, all.items)
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

//MARK: - Create collection
extension Rest {
    public func collectionCreate(collection: UserCollection) async throws -> UserCollection {
        let res: ItemResponse<UserCollection> = try await fetch.post(
            "collection",
            body: collection,
            configuration: .new
        )
        return res.item
    }
}

//MARK: - Update collection
extension Rest {
    public func collectionUpdate(original: UserCollection, changed: UserCollection) async throws -> UserCollection {
        let res: ItemResponse<UserCollection> = try await fetch.put(
            "collection/\(original.id)",
            body: changed,
            configuration: .changed(from: original)
        )
        return res.item
    }
}

//MARK: - Delete collection
extension Rest {
    public func collectionDelete(id: UserCollection.ID) async throws -> Bool {
        let res: ResultResponse = try await fetch.delete(
            "collection/\(id)"
        )
        return res.result
    }
}
