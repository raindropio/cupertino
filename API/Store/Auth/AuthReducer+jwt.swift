import Foundation

extension AuthReducer {
    func jwt(state: inout S, callbackUrl: URL) async throws {
        try await rest.authJWTEnd(callbackUrl)
    }
}
