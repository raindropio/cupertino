extension FiltersStore {
    func reload(find: FindBy) async throws {
        var group = FiltersState.Group()
        let (filters, total) = try await rest.filtersGet(find)
        
        group.raindrops = total
        
        filters.forEach {
            switch $0.kind {
            case .tag(_), .notag: group.tags.append($0)
            case .created(_): group.created.append($0)
            default: group.general.append($0)
            }
        }
                
        try await mutate { state in
            state[find] = group
        }
    }
}
