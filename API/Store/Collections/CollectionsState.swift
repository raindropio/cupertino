import Foundation

public struct CollectionsState: ReduxState {
    public var status = Status.idle
    @Persisted("cos-groups") public var groups = [CGroup]()
    @Persisted("cos-system") public var system = [SystemCollection.ID: SystemCollection]()
    @Persisted("cos-user") public var user = [UserCollection.ID: UserCollection]()
    public var animation = UUID()
    
    public init() {}
}

extension CollectionsState {
    public enum Status: String, Equatable, Codable {
        case idle
        case loading
        case error
    }
}
