//MARK: - Get many
extension Rest {
    public func raindropsGet(
        _ find: FindBy,
        sort: SortBy,
        afterId: Raindrop.ID? = nil
    ) async throws -> [Raindrop] {
        let res: RaindropsGetResponse = try await fetch.get(
            "raindrops/\(find.collectionId)",
            query:
                find.query
                + [
                    .init(name: "sort", value: "\(sort.description)"),
                    .init(name: "perpage", value: "50")
                ]
                //TODO: support afterId
        )
        return res.items
    }
    
    fileprivate struct RaindropsGetResponse: Decodable {
        var items: [Raindrop]
    }
}

//MARK: - Create many
extension Rest {
    public func raindropsCreate(
        _ raindrops: [Raindrop]
    ) async throws -> [Raindrop] {
        []
    }
}

//MARK: - Update many
extension Rest {
    public func raindropsUpdate(
        _ find: FindBy,
        pick: RaindropsPick,
        operation: RaindropsUpdateOperation
    ) async throws -> Int {
        0
    }
    
    public enum RaindropsUpdateOperation {
        case moveTo(Collection.ID)
        case addTags([String])
        case removeTags
        case reparse
        case important(Bool)
    }
}

//MARK: - Remove many
extension Rest {
    public func raindropsDelete(
        _ find: FindBy,
        pick: RaindropsPick
    ) async throws -> Int {
        0
    }
}

//MARK: - Etc
extension Rest {
    public enum RaindropsPick {
        case all
        case ids([Raindrop.ID])
    }
}
