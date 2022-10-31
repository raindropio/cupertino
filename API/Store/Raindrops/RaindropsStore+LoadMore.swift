extension RaindropsStore {
    func loadMore(find: FindBy) async throws {
        //ignore when already loading
        guard await state[find].status == .idle, await state[find].more != .loading
        else { return }
                
        //loading state
        try await mutate {
            $0[find].more = .loading
        }
        
        do {
            let sort = await state.sort(find)
            let nextPage = await state[find].page + 1
            let (items, total) = try await rest.raindropsGet(find, sort: sort, page: nextPage)
            
            //correct page validation
            guard nextPage == (await state[find].page + 1)
            else { return }
            
            //no more pages
            if items.isEmpty {
                try await mutate {
                    $0[find].more = .notFound
                }
                return
            }
            
            //data corruption check
            let existingIds = await state[find].ids
            guard !(items.contains { existingIds.contains($0.id) })
            else {
                try await mutate {
                    $0[find].more = .error
                }
                return
            }
            
            //add to items dictionary and update group
            try await mutate { state in
                items.forEach { state.items[$0.id] = $0 }
                
                state[find].ids = state[find].ids + items.map(\.id)
                state[find].more = total >= state[find].ids.count ? .notFound : .idle
                state[find].page = nextPage
                state[find].total = total
            }
        }
        catch RestError.notFound {
            try await mutate {
                $0[find].more = .notFound
            }
        }
        catch {
            try await mutate {
                $0[find].more = .error
            }
            throw error
        }
    }
}
