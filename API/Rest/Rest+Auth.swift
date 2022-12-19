import Foundation
import AuthenticationServices

//MARK: - Login
extension Rest {
    public func authLogin(_ body: AuthLoginRequest) async throws {
        let res: ResultResponse = try await fetch.post(
            "auth/email/login",
            body: body
        )
        
        guard res.result == true
        else { throw RestError.unauthorized }
    }
}

//MARK: - Logout
extension Rest {
    public func authLogout() async throws {
        do {
            let _: ResultResponse = try await fetch.get(
                "auth/logout",
                query: [.init(name: "no_redirect", value: nil)]
            )
        }
        catch RestError.unauthorized {
            return
        }
        catch {
            throw error
        }
    }
}

//MARK: - Apple
extension Rest {
    public func authApple(credentials: ASAuthorizationAppleIDCredential) async throws {
        guard
            let identityToken = credentials.identityToken,
            let identityTokenString = String(data: identityToken, encoding: .utf8),
            let code = credentials.authorizationCode,
            let codeString = String(data: code, encoding: .utf8),
            let fullName = credentials.fullName
        else {
            throw RestError.invalid("can't get apple sign in credentials")
        }
        
        do {
            let _: ResultResponse = try await fetch.get(
                "auth/apple/native",
                query: [
                    .init(name: "code", value: codeString),
                    .init(name: "identity_token", value: identityTokenString),
                    .init(name: "display_name", value: "\(fullName.familyName ?? "") \(fullName.givenName ?? "") \(fullName.middleName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines))
                ]
            )
        }
        catch RestError.unauthorized {
            return
        }
        catch {
            throw error
        }
    }
}
