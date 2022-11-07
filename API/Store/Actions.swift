//TODO: Support debounce

public enum AuthAction: ReduxAction {
    case login(AuthLoginForm)
    case logout
}

public enum CollectionsAction: ReduxAction {
    //load
    case load
    case reload
    case reloaded([CGroup], [SystemCollection], [UserCollection])
    //create
    case create(UserCollection)
    case created(UserCollection)
    //update
    case update(UserCollection, original: UserCollection? = nil)
    case updated(UserCollection)
    //delete
    case delete(UserCollection.ID)
    case deleted(UserCollection.ID)
    //groups
    case saveGroups
    case groupsUpdated([CGroup])
    //shorthands
    case reorder(UserCollection.ID, parent: UserCollection.ID?, order: Int)
    case setView(Int, CollectionView)
    case toggle(UserCollection.ID)
    case toggleGroup(CGroup.ID)
}

public enum IconsAction: ReduxAction {
    case reload(String = "")
}

public enum RaindropsAction: ReduxAction {
    //load
    case load(FindBy)
    case reload(FindBy)
    case reloaded(FindBy, [Raindrop], Int)
    case sort(FindBy, SortBy)
    //more
    case more(FindBy)
    case moreLoad(FindBy)
    case moreLoaded(FindBy, Int, [Raindrop], Int)
    //single
    case create(Raindrop) // -> createMany
    //multi
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
