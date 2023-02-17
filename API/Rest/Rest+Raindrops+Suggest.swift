import Foundation

//MARK: - Delete raindrop
extension Rest {
    public func raindropSuggest(raindrop: Raindrop) async throws -> RaindropSuggestions {
        let res: ItemResponse<RaindropSuggestions> = try await fetch.post("raindrop/suggest", body: raindrop)
        return res.item
    }
}
