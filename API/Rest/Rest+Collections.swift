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

//MARK: - Update groups
extension Rest {
    public func collectionGroupsUpdate(groups: [CGroup]) async throws -> [CGroup] {
        let res: CollectionGroupsResponse = try await fetch.put(
            "user",
            body: GroupsReq(groups: groups)
        )
        return res.user.groups
    }
    
    fileprivate struct GroupsReq: Encodable {
        var groups: [CGroup]
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
    public func collectionUpdate(original: UserCollection, modified: UserCollection) async throws -> UserCollection {
        let res: ItemResponse<UserCollection> = try await fetch.put(
            "collection/\(original.id)",
            body: modified,
            configuration: .modified(from: original)
        )
        return res.item
    }
}

//MARK: - Update many collection
extension Rest {
    public func collectionUpdateMany(_ form: UpdateCollectionsForm) async throws {
        let _: ResultResponse = try await fetch.put(
            "collections",
            body: form
        )
    }
}

//MARK: - Delete collection
extension Rest {
    public func collectionDelete(id: UserCollection.ID) async throws {
        let res: ResultResponse = try await fetch.delete(
            "collection/\(id)"
        )
        if !res.result {
            throw RestError.unknown("server just ignored")
        }
    }
}
