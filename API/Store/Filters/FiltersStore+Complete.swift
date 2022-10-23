extension FiltersStore {
    func complete(find: FindBy) async throws {
        let group = find.excludingText()
        let base = await state[group]
        
        let completion = (base.tags + base.general + base.created)
            .filter {
                $0.completionEnd(of: find.text) > 0
            }
        
        try await mutate {
            $0.completion[group] = completion
        }
    }
}
