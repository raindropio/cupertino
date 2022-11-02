extension RaindropsReducer {
    func reload(state: inout S, find: FindBy) async throws {
        //default sort
        if !state.exists(find) {
            state[find].sort = SortBy.someCases(for: find).first!
        }
        
        state[find].status = .loading
        
        do {
            let sort = state.sort(find)
            let (items, total) = try await rest.raindropsGet(find, sort: sort)
            
            //add to items dictionary and update group
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
        catch RestError.notFound {
            state[find] = .init()
            state[find].status = .notFound
        }
        catch {
            state[find] = .init()
            state[find].status = .error
            throw error
        }
    }
}
