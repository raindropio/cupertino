import SwiftUI
import API
import UI

struct Collaborators: View {
    @EnvironmentObject private var co: CollaboratorsStore
    @EnvironmentObject private var dispatch: Dispatcher

    @Binding var collection: UserCollection
    
    private var users: [Collaborator] {
        co.state.users(collection.id)
    }
    
    @Sendable
    private func unshareCollection() async throws {
        try await dispatch(CollaboratorsAction.deleteAll(collection.id))
    }
    
    var body: some View {
        if !users.isEmpty {
            ForEach(users) {
                CollaboratorItem(collection: collection, collaborator: $0)
            }
            
            ActionButton("Remove all collaborators", role: .destructive, action: unshareCollection)
        }
    }
}
