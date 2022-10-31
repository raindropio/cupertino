//MARK: - Get many
extension Rest {
    public static let raindropsPerPage = 50
}

//MARK: - Get many
extension Rest {
    public func raindropsGet(
        _ find: FindBy,
        sort: SortBy,
        page: Int = 0
    ) async throws -> ([Raindrop], Int) {
        let res: RaindropsGetResponse = try await fetch.get(
            "raindrops/\(find.collectionId)",
            query:
                find.query
                + [
                    .init(name: "sort", value: "\(sort.description)"),
                    .init(name: "page", value: "\(page)"),
                    .init(name: "perpage", value: "\(Self.raindropsPerPage)")
                ]
        )
        return (res.items, res.count)
    }
    
    fileprivate struct RaindropsGetResponse: Decodable {
        var items: [Raindrop]
        var count: Int
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
        case moveTo(Int)
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
