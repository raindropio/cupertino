//TODO: Support debounce

public enum AuthAction: ReduxAction {
    case login(AuthLoginForm)
    case logout
}

public enum CollectionsAction: ReduxAction {
    //load
    case load
    case reload
    case reloaded([SystemCollection], [UserCollection])
    //create
    case create(UserCollection)
    case created(UserCollection)
    //update
    case update(UserCollection)
    case updated(UserCollection)
    //delete
    case delete(UserCollection.ID)
    case deleted(UserCollection.ID)
    //helpers
    case changeView(Int, CollectionView)
}

public enum IconsAction: ReduxAction {
    case reload(String = "")
}

public enum RaindropsAction: ReduxAction {
    case load(FindBy)
    case reload(FindBy)
    case reloaded(FindBy, [Raindrop], Int)
    case more(FindBy)
    case moreLoad(FindBy)
    case moreLoaded(FindBy, Int, [Raindrop], Int)
    case sort(FindBy, SortBy)
    case create(Raindrop)
    case createMany([Raindrop])
}

public enum FiltersAction: ReduxAction {
    case reload(FindBy = .init())
    case reloaded(FindBy, [Filter])
}

public enum RecentAction: ReduxAction {
    case reload(FindBy = .init())
    case clearSearch
    case clearTags
}

public enum UserAction: ReduxAction {
    case reload
    case reloaded(User)
}
