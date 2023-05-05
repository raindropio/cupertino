extension ConfigReducer {
    func update(state: inout S, raindrops: ConfigRaindrops) -> ReduxAction? {
        state.raindrops = raindrops
        return A.save
    }
    
    func update(state: inout S, collections: ConfigCollections) -> ReduxAction? {
        state.collections = collections
        return A.save
    }
}
