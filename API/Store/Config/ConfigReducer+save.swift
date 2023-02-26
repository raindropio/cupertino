extension ConfigReducer {
    func save(state: inout S) async throws {
        _ = try await rest.configUpdate(state)
    }
}
