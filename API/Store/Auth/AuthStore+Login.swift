extension AuthStore {
    func login(form: AuthLoginForm) async throws {
        try await mutate {
            $0.status.login = .loading
        }
        
        do {
            _ = try await rest.authLogin(form: form)
            
            try await mutate {
                $0.status.login = .idle
            }
            
            dispatch(UserAction.reload)
        }
        catch {
            try await mutate {
                $0.status.login = .error(
                    (error as? RestError) ?? .unknown(error.localizedDescription)
                )
            }
            throw error
        }
    }
}
