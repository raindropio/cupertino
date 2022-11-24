import Foundation

//MARK: - Get
extension Rest {
    public func importUrlParse(_ url: URL) async throws -> Raindrop {
        let res: ItemResponse<Raindrop> = try await fetch.get(
            "import/url/parse",
            query: [
                .init(name: "url", value: url.absoluteString)
            ]
        )
        var raindrop = res.item
        raindrop.link = url
        return raindrop
    }
}
