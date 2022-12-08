import Foundation

extension IconsReducer {
    func load(state: inout S, filter: String) -> ReduxAction? {
        let key = state.filterKey(filter)
        
        //do not reload non empty themes
        guard state.filtered(key).isEmpty
        else { return nil }
        
        state.loading[key] = true
        
        return A.reload(filter)
    }
}

extension IconsReducer {
    func reload(state: inout S, filter: String) async throws -> ReduxAction? {
        let key = state.filterKey(filter)
        
        do {
            return A.reloaded(filter, try await rest.iconsGet(key))
        } catch {
            state.loading[key] = false
            throw error
        }
    }
}

extension IconsReducer {
    func reloaded(state: inout S, filter: String, icons: [URL]) {
        let key = state.filterKey(filter)
        state.icons[key] = icons
        state.loading[key] = false
    }
}
