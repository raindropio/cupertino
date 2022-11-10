public struct CollectionsState: ReduxState {
    public var status = Status.idle
    @Cached("cos-groups") public var groups = [CGroup]()
    @Cached("cos-system") public var system = [SystemCollection.ID: SystemCollection]()
    @Cached("cos-user") public var user = [UserCollection.ID: UserCollection]()
    
    public init() {}
}

extension CollectionsState {
    public enum Status: String, Equatable, Codable {
        case idle
        case loading
        case error
    }
}
