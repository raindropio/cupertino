import Foundation

extension AuthReducer {
    func tfa(state: S, token: String, code: String) async throws {
        try await rest.authTfa(token: token, code: code)
    }
}
