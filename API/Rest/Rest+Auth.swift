import Foundation

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
