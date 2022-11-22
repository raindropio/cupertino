import Foundation

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
        let res: ItemsResponse<Raindrop> = try await fetch.get(
            "raindrops/\(find.collectionId)",
            query:
                find.query
                + [
                    .init(name: "sort", value: "\(sort.description)"),
                    .init(name: "page", value: "\(page)"),
                    .init(name: "perpage", value: "\(Self.raindropsPerPage)")
                ]
        )
        return (res.items, res.count ?? 0)
    }
}

//MARK: - Create raindrop
extension Rest {
    public func raindropCreate(raindrop: Raindrop) async throws -> Raindrop {
        let res: ItemResponse<Raindrop> = try await fetch.post(
            "raindrop",
            body: raindrop,
            configuration: .new
        )
        return res.item
    }
}

//MARK: - Create many
extension Rest {
    public func raindropsCreate(
        _ raindrops: [Raindrop]
    ) async throws -> [Raindrop] {
        let res: ItemsResponse<Raindrop> = try await fetch.post(
            "raindrops",
            body: ItemsRequest(items: raindrops),
            configuration: .new
        )
        return res.items
    }
}

//MARK: - Update raindrop
extension Rest {
    public func raindropUpdate(original: Raindrop, modified: Raindrop) async throws -> Raindrop {
        let res: ItemResponse<Raindrop> = try await fetch.put(
            "raindrop/\(original.id)",
            body: modified,
            configuration: .modified(from: original)
        )
        return res.item
    }
}

//MARK: - Update many
extension Rest {
    public func raindropsUpdate(
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

//MARK: - Delete raindrop
extension Rest {
    public func raindropDelete(id: Raindrop.ID) async throws {
        let res: ResultResponse = try await fetch.delete(
            "raindrop/\(id)"
        )
        if !res.result {
            throw RestError.unknown("server just ignored")
        }
    }
}

//MARK: - Remove many
extension Rest {
    public func raindropsDelete(
        pick: RaindropsPick
    ) async throws -> Int {
        switch pick {
        case .all(let find):
            let res: ModifiedResponse = try await fetch.delete(
                "raindrops/\(find.collectionId)",
                query: find.query
            )
            return res.modified
            
        case .some(let ids):
            guard !ids.isEmpty else { return 0 }
            
            let res: ModifiedResponse = try await fetch.delete(
                "raindrops/0",
                body: IdsRequest(ids: ids)
            )
            
            //maybe it's permanent remove request?
            if res.modified == 0 {
                let retry: ModifiedResponse = try await fetch.delete(
                    "raindrops/-99",
                    body: IdsRequest(ids: ids)
                )
                return retry.modified
            }
            
            return res.modified
        }
    }
}

extension Rest {
    public static func raindropCacheLink(_ id: Raindrop.ID) -> URL {
        .init(string: "raindrop/\(id)/cache", relativeTo: base.api)!
    }
}

//MARK: - Etc
extension Rest {
    public enum RaindropsPick: Equatable {
        case all(FindBy)
        case some([Raindrop.ID])
    }
}
