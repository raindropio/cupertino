import Foundation

struct AuthResponse: Decodable {
    var result: Bool
    var tfa: String?
}
