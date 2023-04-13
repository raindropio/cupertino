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

//MARK: - Pusher
extension Rest {
    public func userPusherAuthToken() async throws -> String {
        let res: UserPusherAuthResponse = try await fetch.get("user/pusher/auth")
        return res.token
    }
    
    fileprivate struct UserPusherAuthResponse: Decodable {
        var token: String
    }
}
