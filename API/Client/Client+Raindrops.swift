extension Client {
    struct Raindrops {}
}

//MARK: - Get
extension Client.Raindrops {
    static func get(
        _ find: FindBy,
        sort: SortBy,
        afterId: Raindrop.ID? = nil
    ) async throws -> [Raindrop] {
        []
    }
}

//MARK: - Create
extension Client.Raindrops {
    static func create(
        _ raindrops: [Raindrop]
    ) async throws -> [Raindrop] {
        []
    }
}

//MARK: - Update
extension Client.Raindrops {
    static func update(
        _ find: FindBy,
        pick: Pick,
        operation: UpdateOperation
    ) async throws -> Int {
        0
    }
    
    internal enum UpdateOperation {
        case moveTo(Collection.ID)
        case addTags([String])
        case removeTags
        case reparse
        case important(Bool)
    }
}

//MARK: - Delete
extension Client.Raindrops {
    static func delete(
        _ find: FindBy,
        pick: Pick
    ) async throws -> Int {
        0
    }
}

//MARK: - Helpers
extension Client.Raindrops {
    internal enum Pick {
        case all
        case ids([Raindrop.ID])
    }
}
