extension RaindropsStore {
    func reload(find: FindBy, sort: SortBy) async throws {
        let oldStatus = await state.status(find)
        let isEmpty = await state.isEmpty(find)
        
        if isEmpty || oldStatus != .idle {
            try await mutate { state in
                state[find].status = .loading
            }
        }
        
        do {
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
