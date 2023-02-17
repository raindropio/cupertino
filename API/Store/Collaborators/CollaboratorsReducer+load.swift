import Foundation

extension CollaboratorsReducer {
    func load(state: inout S, collectionId: UserCollection.ID) -> ReduxAction? {
        state.loading[collectionId] = true
        return A.reload(collectionId)
    }
}

extension CollaboratorsReducer {
    func reload(state: inout S, collectionId: UserCollection.ID) async throws -> ReduxAction? {
        do {
            return A.reloaded(collectionId, try await rest.collaboratorsGet(collectionId))
        } catch {
            state.loading[collectionId] = false
            throw error
        }
    }
}

extension CollaboratorsReducer {
    func reloaded(state: inout S, collectionId: UserCollection.ID, users: [Collaborator]) {
        state.users[collectionId] = users
        state.loading[collectionId] = false
    }
}
