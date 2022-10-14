public enum RaindropAction: ReduxAction {
    case reload(FindBy, SortBy)
    case loadMore(FindBy, SortBy)
    case create(Raindrop)
    case createMany([Raindrop])
}
