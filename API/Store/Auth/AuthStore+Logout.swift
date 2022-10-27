extension AuthStore {
    func logout() async throws {
        try await mutate {
            $0.status.logout = .loading
        }
        
        do {
            _ = try await rest.authLogout()
            try await mutate {
                $0.status.logout = .idle
            }
        }
        catch {
            try await mutate {
                $0.status.logout = .error(
                    (error as? RestError) ?? .unknown(error.localizedDescription)
                )
            }
            throw error
        }
    }
}
