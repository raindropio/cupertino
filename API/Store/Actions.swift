//TODO: Support debounce

public enum AuthAction: ReduxAction {
    case login(AuthLoginForm)
    case logout
}

public enum CollectionsAction: ReduxAction {
    case reload
    case update(UserCollection)
    case changeView(UserCollection.ID, CollectionView)
}

public enum IconsAction: ReduxAction {
    case reload(String = "")
}

public enum RaindropsAction: ReduxAction {
    case reload(FindBy)
    case loadMore(FindBy)
    case sort(FindBy, SortBy)
    case create(Raindrop)
    case createMany([Raindrop])
}

public enum FiltersAction: ReduxAction {
    case reload(FindBy = .init())
}

public enum RecentAction: ReduxAction {
    case reload(FindBy = .init())
    case clearSearch
    case clearTags
}

public enum UserAction: ReduxAction {
    case reload
}
