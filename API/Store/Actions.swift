import SwiftUI

//TODO: Support debounce

public enum AuthAction: ReduxAction {
    case login(AuthLoginRequest)
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
    case updateMany(UpdateCollectionsRequest)
    //delete
    case delete(UserCollection.ID)
    case deleted(UserCollection.ID)
    //groups
    case saveGroups
    case groupsUpdated([CGroup])
    //shorthands
    case reorder(UserCollection.ID, parent: UserCollection.ID?, order: Int)
    case reorderMany(UpdateCollectionsRequest.Sort)
    case setView(Int, CollectionView)
    case toggle(UserCollection.ID)
    case toggleMany
    case toggleGroup(CGroup)
    case renameGroup(CGroup)
    case deleteGroup(CGroup)
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
    //create
    case create(Raindrop) // -> createMany
    //update
    case update(Raindrop)
    case updated(Raindrop)
    case updateMany(RaindropsPick, UpdateRaindropsRequest)
    case updatedMany(RaindropsPick, UpdateRaindropsRequest)
    //delete
    case delete(Raindrop.ID) // -> deleteMany
    case deleteMany(RaindropsPick)
    case deletedMany(RaindropsPick)
    //add web url or file url
    case add(Set<URL>, collection: Int? = nil, completed: Binding<Set<URL>>? = nil, failed: Binding<Set<URL>>? = nil)
    //multi
    case createMany([Raindrop])
    case createdMany([Raindrop])
    //shorthands
    case reorder(Raindrop.ID, to: Int? = nil, order: Int)
    //helpers
    case find(Binding<Raindrop>)
}

public enum FiltersAction: ReduxAction {
    case reload(FindBy = .init())
    case reloaded(FindBy, [Filter], FiltersConfig?)
    case toggleSimple
    case toggleTags
    case saveConfig
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
