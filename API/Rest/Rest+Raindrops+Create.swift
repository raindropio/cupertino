import Foundation

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
