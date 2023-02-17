import Foundation

public struct CollaboratorsState: ReduxState {
    @Cached("clb-users") var users = [UserCollection.ID: [Collaborator]]()
    var loading = [UserCollection.ID: Bool]()
    
    public init() {}
    
    public func users(_ collectionId: UserCollection.ID) -> [Collaborator] {
        users[collectionId] ?? .init()
    }
    
    public func loading(_ collectionId: UserCollection.ID) -> Bool {
        loading[collectionId] ?? false
    }
}
