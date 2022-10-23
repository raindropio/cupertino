//TODO: Support debounce

public enum RaindropsAction: ReduxAction {
    case reload(FindBy, SortBy)
    case loadMore(FindBy, SortBy)
    case create(Raindrop)
    case createMany([Raindrop])
}

public enum FiltersAction: ReduxAction {
    case reload(FindBy)
    case complete(FindBy)
}
