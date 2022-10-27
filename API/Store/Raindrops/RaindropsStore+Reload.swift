extension RaindropsStore {
    func reload(find: FindBy) async throws {
        let exists = await state.exists(find)
        
        //first run
        if !exists {
            try await mutate { state in
                //default sort
                state[find].sort = SortBy.someCases(for: find).first!
                
                //only change status when there never run
                state[find].status = .loading
            }
        }
        
        do {
            let sort = await state.sort(find)
            let items = try await rest.raindropsGet(find, sort: sort)
            
            //add to items dictionary and update group
            try await mutate { state in
                items.forEach { state.items[$0.id] = $0 }
                state[find].ids = items.map(\.id)
                state[find].status = .idle
            }
        } catch {
            //set specific error
            try await mutate { state in
                state[find].status = {
                    if let error = error as? RestError,
                       case .notFound = error {
                        return .notFound
                    }
                    return .error
                }()
            }
            throw error
        }
    }
}
