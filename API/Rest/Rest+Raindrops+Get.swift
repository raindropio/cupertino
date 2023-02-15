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
    public func raindropGet(id: Raindrop.ID) async throws -> Raindrop? {
        let res: ItemResponse<Raindrop> = try await fetch.get(
            "raindrop/\(id)"
        )
        return res.item
    }
}
