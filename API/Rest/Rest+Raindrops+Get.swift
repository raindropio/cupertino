import Foundation

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

extension Rest {
    //TODO: use raindrops/links endpoint instead, should work faster due to caching
    public func raindropId(link: URL) async throws -> Raindrop.ID? {
        let exists: IdsResponse<Raindrop.ID> = try await fetch.get(
            "import/url/exists",
            query: [
                .init(name: "url", value: link.absoluteString)
            ]
        )
        return exists.ids.first
    }
    
    public func raindropGet(id: Raindrop.ID) async throws -> Raindrop? {
        let res: ItemResponse<Raindrop> = try await fetch.get(
            "raindrop/\(id)"
        )
        return res.item
    }
    
    public func raindropGet(link: URL) async throws -> Raindrop? {
        guard let id = try await raindropId(link: link)
        else { return nil }
        return try await raindropGet(id: id)
    }
}
