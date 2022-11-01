extension RaindropsStore {
    func reload(find: FindBy) async throws {
        try await mutate { state in
            //default sort
            if !state.exists(find) {
                state[find].sort = SortBy.someCases(for: find).first!
            }
            
            state[find].status = .loading
        }
        
        do {
            let sort = await state.sort(find)
            let (items, total) = try await rest.raindropsGet(find, sort: sort)
            
            //add to items dictionary and update group
            try await mutate { state in
                items.forEach { state.items[$0.id] = $0 }
                
                //do not override if data is not changed (useful for pagination)
                let oldIds = state[find].ids
                let newIds = items.map(\.id)

                if oldIds.count < newIds.count || oldIds[0..<newIds.count] != newIds[0..<newIds.count] {
                    state[find].ids = newIds
                    state[find].page = 0
                }
                
                state[find].status = .idle
                state[find].more = state[find].ids.count >= total ? .notFound : .idle
                state[find].total = total
            }
        }
        catch RestError.notFound {
            try await mutate {
                $0[find] = .init()
                $0[find].status = .notFound
            }
        }
        catch {
            try await mutate {
                $0[find] = .init()
                $0[find].status = .error
            }
            throw error
        }
    }
}
