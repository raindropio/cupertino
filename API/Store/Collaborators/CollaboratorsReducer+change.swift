extension CollaboratorsReducer {
    func change(state: inout S, collectionId: UserCollection.ID, userId: Collaborator.ID, level: CollectionAccess.Level) async throws {
        try await rest.collaboratorChange(collectionId, userId: userId, level: level)
        
        let index = state.users[collectionId]?.firstIndex { $0.id == userId }
        if let index {
            state.users[collectionId]?[index].level = level
        }
    }
}
