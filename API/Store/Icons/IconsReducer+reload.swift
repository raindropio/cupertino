extension IconsReducer {
    func reload(state: inout S, filter: String) async throws {
        let key = state.filterKey(filter)
        
        //do not reload non empty themes
        guard state.filtered(key).isEmpty
        else { return }
        
        let icons = try await rest.iconsGet(key)
        state.icons[key] = icons
    }
}
