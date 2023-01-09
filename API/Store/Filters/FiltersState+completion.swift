import Foundation

extension FiltersState {
    public func completion(_ find: FindBy) -> [Filter] {
        //doesn't need completion
        guard !find.text.trimmingCharacters(in: .whitespaces).isEmpty
        else { return [] }
        
        let base = find.excludingText()
        
        return (
            (tags[base] ?? []) +
            (simple[base] ?? []) +
            (created[base] ?? [])
        )
            .filter {
                $0.contains(find.text)
            }
    }
}
