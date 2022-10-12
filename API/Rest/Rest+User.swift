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
