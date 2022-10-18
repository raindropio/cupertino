extension FiltersStore {
    func reload(find: FindBy) async throws {
        try await mutate { state in
            state[find].status = .loading
        }
        
        do {
            let items = try await rest.filtersGet(find)
            
            //add to items dictionary and update group
            try await mutate { state in
                state[find].simple = items.filter {
                    switch $0.kind {
                    case .tag(_), .created(_), .notag: return false
                    default: return true
                    }
                }
                state[find].tags = items.filter {
                    switch $0.kind {
                    case .tag(_), .notag: return true
                    default: return false
                    }
                }
                state[find].created = items.filter {
                    switch $0.kind {
                    case .created(_): return true
                    default: return false
                    }
                }
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
