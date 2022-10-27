extension CollectionsStore {
    func reload() async throws {
        let oldStatus = await state.status
        let isEmpty = await state.isEmpty()
        
        if isEmpty || oldStatus != .idle {
            try await mutate { state in
                state.status = .loading
            }
        }
        
        do {
            let (system, user) = try await rest.collectionsGet()
            
            try await mutate { state in
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
            }
        } catch {
            //set specific error
            try await mutate { state in
                state.status = .error
            }
            throw error
        }
    }
}
