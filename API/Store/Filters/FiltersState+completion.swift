import Foundation

extension FiltersState {
    public func completion(_ find: FindBy) -> [Filter] {
        //doesn't need completion
        guard !find.text.trimmingCharacters(in: .whitespaces).isEmpty
        else { return [] }
        
        if MemCache.store[find] == nil {
            let base = find.excludingText()
            
            MemCache.store[find] = (
                (tags[base] ?? []) +
                (simple[base] ?? []) +
                (created[base] ?? [])
            )
                .filter {
                    $0.completionEnd(of: find.text) > 0
                }
        }
        
        return MemCache.store[find] ?? []
    }
    
    /// Ignore completion filters
    func withoutCompletion(_ find: FindBy, _ filters: [Filter]?) -> [Filter] {
        guard let filters else { return [] }
        guard !find.text.trimmingCharacters(in: .whitespaces).isEmpty else { return filters }
        
        let completionKinds = completion(find).map { $0.kind }
        return filters.filter { !completionKinds.contains($0.kind) }
    }
}

fileprivate final class MemCache {
    static var store = [FindBy: [Filter]]()
}
