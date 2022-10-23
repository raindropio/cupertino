//TODO: Support debounce

public enum AuthAction: ReduxAction {
    case login(AuthLoginForm)
    case logout
}

public enum RaindropsAction: ReduxAction {
    case reload(FindBy, SortBy)
    case loadMore(FindBy, SortBy)
    case create(Raindrop)
    case createMany([Raindrop])
}

public enum FiltersAction: ReduxAction {
    case reload(FindBy)
}

public enum UserAction: ReduxAction {
    case reload
}
