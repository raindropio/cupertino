import Foundation

extension Rest {
    fileprivate struct AuthGenericResponse: Decodable {
        var result: Bool
    }
}

//MARK: - Login
extension Rest {
    public func authLogin(form: AuthLoginForm) async throws -> Bool {
        let res: AuthGenericResponse = try await fetch.post("auth/email/login", body: form)
        return res.result
    }
}

//MARK: - Logout
extension Rest {
    public func authLogout() async throws -> Bool {
        do {
            let res: AuthGenericResponse = try await fetch.get(
                "auth/logout",
                query: [.init(name: "no_redirect", value: nil)]
            )
            return res.result
        }
        catch RestError.unauthorized {
            return true
        }
        catch {
            throw error
        }
    }
}
