import Foundation

//MARK: - Get
extension Rest {
    public func userGet() async throws -> User {
        let res: UserResponse = try await fetch.get("user")
        return res.user
    }
    
    fileprivate struct UserResponse: Decodable {
        var user: User
    }
}

//MARK: - FCM
extension Rest {
    public func userConnectFCMDevice(token: String) async throws {
        try await fetch.post("user/connect/fcm_device", body: UserConnectFCMDevice(token: token))
    }
    
    fileprivate struct UserConnectFCMDevice: Encodable {
        var token: String
    }
}
