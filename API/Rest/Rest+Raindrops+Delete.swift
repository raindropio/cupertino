import Foundation

//MARK: - Delete raindrop
extension Rest {
    public func raindropDelete(id: Raindrop.ID) async throws {
        let res: ResultResponse = try await fetch.delete(
            "raindrop/\(id)"
        )
        if !res.result {
            throw RestError.unknown("server just ignored")
        }
    }
}

//MARK: - Remove many
extension Rest {
    public func raindropsDelete(pick: RaindropsPick) async throws -> Int {
        switch pick {
        case .all(let find):
            let res: ModifiedResponse = try await fetch.delete(
                "raindrops/\(find.collectionId)",
                query: find.query
            )
            return res.modified
            
        case .some(let ids):
            guard !ids.isEmpty else { return 0 }
            
            let body = IdsRequest(ids: Array(ids))
            let res: ModifiedResponse = try await fetch.delete("raindrops/0", body: body)
            
            //maybe it's permanent remove request?
            if res.modified == 0 {
                let retry: ModifiedResponse = try await fetch.delete("raindrops/-99", body: body)
                return retry.modified
            }
            
            return res.modified
        }
    }
}
