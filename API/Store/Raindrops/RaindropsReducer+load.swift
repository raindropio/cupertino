extension RaindropsReducer {
    //MARK: - 1
    func load(state: inout S, find: FindBy) -> ReduxAction? {
        //default sort
        if !state.exists(find) {
            state[find].sort = SortBy.someCases(for: find).first!
        }
        
        state[find].status = .loading
        
        return A.reload(find)
    }
    
    //MARK: - 2
    func reload(state: inout S, find: FindBy) async throws -> ReduxAction? {
        do {
            let sort = state.sort(find)
            let (items, total) = try await rest.raindropsGet(find, sort: sort)
            return A.reloaded(find, items, total)
        }
        catch RestError.notFound {
            state[find] = .init()
            state[find].status = .notFound
        }
        catch is CancellationError {
            state[find].validMore()
        }
        catch {
            state[find] = .init()
            state[find].status = .error
            throw error
        }
        return nil
    }
    
    //MARK: - 3
    func reloaded(state: inout S, find: FindBy, items: [Raindrop], total: Int) {
        //add to items dictionary and update group
        items.forEach { state.items[$0.id] = $0 }
        
        //do not override if data is not modified (useful for pagination)
        let oldIds = state[find].ids
        let newIds = items.map(\.id)

        if oldIds.count < newIds.count || oldIds[0..<newIds.count] != newIds[0..<newIds.count] {
            state[find].ids = newIds
            state[find].page = 0
        }
        
        state[find].status = .idle
        state[find].total = total
        state[find].validMore()
    }
}
