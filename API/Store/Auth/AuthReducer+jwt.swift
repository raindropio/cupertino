import Foundation

extension AuthReducer {
    func jwt(state: S, callbackUrl: URL) async throws {
        try await rest.authJWTEnd(callbackUrl)
    }
}
