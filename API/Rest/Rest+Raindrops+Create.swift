import Foundation

//MARK: - Create raindrop
extension Rest {
    public func raindropCreate(raindrop: Raindrop) async throws -> Raindrop {
        //make sure to reparse if no meta
        var raindrop = raindrop
        if raindrop.type == .link, raindrop.pleaseParse == nil {
            raindrop.pleaseParse = .init()
        }
        
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
            body: ItemsRequest(items: raindrops.map {
                //make sure to reparse if no meta
                var raindrop = $0
                if raindrop.type == .link, raindrop.pleaseParse == nil {
                    raindrop.pleaseParse = .init(weight: raindrops.count)
                }
                return raindrop
            }),
            configuration: .new
        )
        return res.items
    }
}
