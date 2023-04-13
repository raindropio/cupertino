import API
import PushNotifications

class PusherTokenProvider: TokenProvider {
    static let shared = PusherTokenProvider()
    
    let rest = Rest()
    
    func fetchToken(userId: String, completionHandler completion: @escaping (String, Error?) -> Void) throws {
        Task {
            do {
                let token = try await rest.userPusherAuthToken()
                completion(token, nil)
            } catch {
                completion("", error)
            }
        }
    }
}
