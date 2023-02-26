extension ConfigReducer {
    func update(state: inout S, raindrops: ConfigRaindrops) -> ReduxAction? {
        state.raindrops = raindrops
        return A.save
    }
}
