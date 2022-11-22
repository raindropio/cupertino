import Foundation

//MARK: - Update raindrop
extension Rest {
    public func raindropUpdate(
        original: Raindrop,
        modified: Raindrop
    ) async throws -> Raindrop {
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
        operation: UpdateRaindropsRequest
    ) async throws -> Int {
        switch pick {
        case .all(let find):
            let res: ModifiedResponse = try await fetch.put(
                "raindrops/\(find.collectionId)",
                query: find.query,
                body: operation
            )
            return res.modified
            
        case .some(let ids):
            guard !ids.isEmpty else { return 0 }
            
            let body = IdsCombineRequest(
                ids: ids,
                combine: operation
            )
            
            let res: ModifiedResponse = try await fetch.put("raindrops/0", body: body)
            
            //maybe they located in trash folder?
            if res.modified == 0 {
                let retry: ModifiedResponse = try await fetch.put("raindrops/-99", body: body)
                return retry.modified
            }
            
            return res.modified
        }
    }
}
