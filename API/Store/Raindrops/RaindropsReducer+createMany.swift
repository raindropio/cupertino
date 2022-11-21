extension RaindropsReducer {
    func createMany(state: inout S, items: [Raindrop]) async throws -> ReduxAction? {
        let new = try await rest.raindropsCreate(items)
        return A.createdMany(new)
    }
    
    func createdMany(state: inout S, items: [Raindrop]) {
        
    }
}
