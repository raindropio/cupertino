import SwiftUI
import AuthenticationServices
import StoreKit

//TODO: Support debounce

public enum AuthAction: ReduxAction {
    case login(AuthLoginRequest)
    case signup(AuthSignupRequest)
    case logout
    case apple(ASAuthorization)
    case google(String)
    case jwt(URL)
    case tfa(token: String, code: String)
}

public enum CollaboratorsAction: ReduxAction {
    case load(UserCollection.ID)
    case reload(UserCollection.ID)
    case reloaded(UserCollection.ID, [Collaborator])
    case reloadFailed(UserCollection.ID, Error)
    case invite(UserCollection.ID, InviteCollaboratorRequest, link: Binding<URL?>)
    case deleteAll(UserCollection.ID)
    case change(UserCollection.ID, userId: Collaborator.ID, level: CollectionAccess.Level)
    case changed(UserCollection.ID, userId: Collaborator.ID, level: CollectionAccess.Level)
}

public enum CollectionsAction: ReduxAction {
    //load
    case load
    case reload
    case reloaded([CGroup], [SystemCollection], [UserCollection])
    case reloadFailed(Error)
    //create
    case create(UserCollection)
    case created(UserCollection)
    //update
    case update(UserCollection, original: UserCollection? = nil)
    case updated(UserCollection)
    case updateMany(UpdateCollectionsRequest)
    //delete
    case delete(UserCollection.ID) // -> deleteMany([], nested: true)
    case deleteMany(Set<UserCollection.ID>, nested: Bool)
    //merge
    case merge(Set<UserCollection.ID>, nested: Bool)
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

public enum ConfigAction: ReduxAction {
    case load
    case reloaded(ConfigState)
    case updateCollections(ConfigCollections)
    case updateRaindrops(ConfigRaindrops)
    case save
}

public enum IconsAction: ReduxAction {
    case load(String = "")
    case reload(String)
    case reloaded(String, [URL])
    case reloadFailed(String, Error)
}

public enum RaindropsAction: ReduxAction {
    //load
    case load(FindBy)
    case reload(FindBy)
    case reloaded(FindBy, [Raindrop], Int)
    case reloadFailed(FindBy, Error)
    case sort(FindBy, SortBy)
    //more
    case more(FindBy)
    case moreLoad(FindBy)
    case moreLoaded(FindBy, Int, [Raindrop], Int)
    case moreFailed(FindBy, Int, Error)
    //single
    case lookup(URL)
    case loaded(Raindrop)
    case suggest(Raindrop)
    case suggested(URL, RaindropSuggestions)
    case enrich(Binding<Raindrop>)
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
    //multi
    case add(Set<URL>, collection: Int? = nil, completed: Binding<Set<URL>>? = nil, failed: Binding<Set<URL>>? = nil)
    case createMany([Raindrop])
    case createdMany([Raindrop])
    //shorthands
    case reorder(Raindrop.ID, to: Int? = nil, order: Int)
}

public enum FiltersAction: ReduxAction {
    case reload(FindBy = .init())
    case reloaded(FindBy, [Filter])
    case sort(TagsSort)
    case update(Set<String>, newName: String)
    case delete(Set<String>)
}

public enum RecentAction: ReduxAction {
    case reload(FindBy = .init())
    case reloaded(FindBy, search: [String], tags: [String])
    case clearSearch
    case clearTags
}

public enum SubscriptionAction: ReduxAction {
    case load
    case reload
    case reloaded(Subscription)
    case reloadFailed(Error)
    case products
    case productsLoaded([Product])
    case purchase(User.ID, StoreKit.Product)
    case purchasing(User.ID, StoreKit.Product)
    case purchased(StoreKit.Transaction)
    case restore
}

public enum UserAction: ReduxAction {
    case reload
    case reloaded(User)
    case connectFCMDevice(_ token: String)
}
