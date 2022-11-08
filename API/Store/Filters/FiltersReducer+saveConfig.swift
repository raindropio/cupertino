extension FiltersReducer {
    func saveConfig(state: inout S) async throws {
        let _ = try await rest.configUpdate(state.config)
    }
}
