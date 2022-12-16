import Foundation

extension Rest {
    fileprivate struct Container: Decodable {
        var highlights: [Highlight]
    }
}

//MARK: - Get
extension Rest {
    public func highlightsGet(_ id: Raindrop.ID) async throws -> [Highlight] {
        let res: ItemResponse<Container> = try await fetch.get("raindrop/\(id)")
        return res.item.highlights
    }
}
