extension ConfigReducer {
    func save(state: S) async throws {
        _ = try await rest.configUpdate(state)
    }
}
