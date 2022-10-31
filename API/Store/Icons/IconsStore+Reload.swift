extension IconsStore {
    func reload(filter: String) async throws {
        let key = await state.filterKey(filter)
        
        //do not reload non empty themes
        guard await state.icons(key).isEmpty
        else { return }
        
        let icons = try await rest.iconsGet(key)
        try await mutate {
            $0.icons[key] = icons
        }
    }
}
