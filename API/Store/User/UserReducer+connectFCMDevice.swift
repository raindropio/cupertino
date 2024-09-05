extension UserReducer {
    func connectFCMDevice(state: S, token: String) async throws {
        try await rest.userConnectFCMDevice(token: token)
    }
}
