import Foundation

//MARK: - Parse URL
extension Rest {
    public func importUrlParse(_ url: URL) async throws -> Raindrop {
        let res: ItemResponse<Raindrop> = try await fetch.get(
            "import/url/parse",
            query: [
                .init(name: "url", value: url.scheme != nil ? url.absoluteString : url.withScheme("https").absoluteString)
            ]
        )
        var raindrop = res.item
        raindrop.link = url
        return raindrop
    }
}
