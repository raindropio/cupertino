extension RaindropsReducer {
    func createMany(state: inout S, items: [Raindrop]) async throws {
        print("create many", items)
    }
}
