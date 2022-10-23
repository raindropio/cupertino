extension AuthStore {
    func logout() async throws {
        try await mutate {
            $0.status.logout = .loading
        }
        
        do {
            _ = try await rest.authLogout()
        }
        //prevent cycle (already logged out)
        catch RestError.unauthorized {
        }
        //some other error
        catch {
            try await mutate {
                $0.status.logout = .error(
                    (error as? RestError) ?? .unknown(error.localizedDescription)
                )
            }
            throw error
        }
        
        //job done
        try await mutate {
            $0.status.logout = .idle
        }
    }
}
