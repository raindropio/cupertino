import Foundation

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

//MARK: - Get single
extension Rest {
    public func raindropGet(id: Raindrop.ID) async throws -> Raindrop? {
        let res: ItemResponse<Raindrop> = try await fetch.get(
            "raindrop/\(id)"
        )
        return res.item
    }
}

//MARK: - Get ID
extension Rest {
    public func raindropGetId(url: URL) async throws -> Raindrop.ID? {
        let map = try await raindropsGetId(urls: [url])
        return map.first?.value
    }
    
    public func raindropsGetId(urls: Set<URL>) async throws -> [URL: Raindrop.ID] {
        let res: RaindropGetIdResponse = try await fetch.post(
            "import/url/exists",
            body: RaindropGetIdRequest(urls: urls)
        )
        var map = [URL: Raindrop.ID]()
        
        for item in res.duplicates {
            map[item.link] = item.id
            map[item.link.compact] = item.id
        }
        
        return map
    }
    
    fileprivate struct RaindropGetIdRequest: Encodable {
        var urls: Set<URL>
    }
    
    fileprivate struct RaindropGetIdResponse: Decodable {
        var duplicates: [Duplicate]
        
        struct Duplicate: Decodable {
            var id: Raindrop.ID
            var link: URL
        }
    }
}
