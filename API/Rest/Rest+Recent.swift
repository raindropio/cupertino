import Foundation

extension Rest {
    fileprivate struct ItemId: Decodable {
        var _id: String
    }
}

//MARK: - Recent search
extension Rest {
    public func recentSearch() async throws -> [String] {
        let res: ItemsResponse<ItemId> = try await fetch.get("raindrops/recent/search")
        return res.items.map { $0._id }
    }
}

//MARK: - Recent tags
extension Rest {
    public func recentTags() async throws -> [String] {
        let res: ItemsResponse<ItemId> = try await fetch.get("tags/recent")
        return res.items.map { $0._id }
    }
}

//MARK: - Clear recent search
extension Rest {
    public func clearRecentSearch() async throws {
        try await fetch.delete("raindrops/recent/search")
    }
}

//MARK: - Clear recent tags
extension Rest {
    public func clearRecentTags() async throws {
        try await fetch.delete("tags/recent")
    }
}
