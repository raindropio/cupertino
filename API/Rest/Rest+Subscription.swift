import Foundation

//MARK: - Get
extension Rest {
    public func subscriptionGet() async throws -> Subscription {
        let res: Subscription = try await fetch.get("user/subscription")
        return res
    }
}

//MARK: - Restore
extension Rest {
    public func subscriptionRestore(receipt: String) async throws {
        let res: RestoreResponse = try await fetch.post(
            "user/subscription/apple_restore",
            body: RestoreRequest(receipt: receipt)
        )
        
        if res.valid != true {
            throw RestError.subscriptionRestoreReceiptInvalid
        }
    }
    
    fileprivate struct RestoreRequest: Encodable {
        var receipt: String
    }
    
    fileprivate struct RestoreResponse: Decodable {
        var valid: Bool?
    }
}
