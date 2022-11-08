import Foundation

fileprivate struct ConfigResponse<C: Decodable>: Decodable {
    var user: U
    
    struct U: Decodable {
        var config: C
    }
}

fileprivate struct ConfigBody<C: Encodable>: Encodable {
    var config: C
}

//MARK: - Get
extension Rest {
    public func configGet<C: Decodable>() async throws -> C {
        let res: ConfigResponse<C> = try await fetch.get("user")
        return res.user.config
    }
}

//MARK: - Update
extension Rest {
    public func configUpdate<C: Codable>(_ config: C) async throws -> C {
        let res: ConfigResponse<C> = try await fetch.put(
            "user",
            body: ConfigBody(config: config)
        )
        return res.user.config
    }
}
