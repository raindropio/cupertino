import Foundation

//MARK: - Recent search
extension Rest {
    public func recentSearch() async throws -> [String] {
        let res: RecentSearchResponse = try await fetch.get("raindrops/recent/search")
        return res.items.map { $0._id }
    }
    
    fileprivate struct RecentSearchResponse: Decodable {
        var items: [Item]
        
        struct Item: Decodable {
            var _id: String
        }
    }
}

//MARK: - Recent tags
extension Rest {
    public func recentTags() async throws -> [String] {
        let res: RecentTagsResponse = try await fetch.get("tags/recent")
        return res.items.map { $0._id }
    }
    
    fileprivate struct RecentTagsResponse: Decodable {
        var items: [Item]
        
        struct Item: Decodable {
            var _id: String
        }
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
