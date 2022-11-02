extension CollectionsReducer {
    func reload(state: inout S) async throws {
        let oldStatus = state.status
        let isEmpty = state.isEmpty()
        
        if isEmpty || oldStatus != .idle {
            state.status = .loading
        }
        
        do {
            let (system, user) = try await rest.collectionsGet()
            
            //system
            system.forEach {
                var item = $0
                //do not override view
                item.view = state.system[$0.id]?.view ?? item.view
                state.system[$0.id] = item
            }
            //user
            user.forEach { state.user[$0.id] = $0 }
            //status
            state.status = .idle
        } catch {
            state.status = .error
            throw error
        }
    }
}
