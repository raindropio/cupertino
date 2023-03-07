extension CollaboratorsReducer {
    func invite(state: S, collectionId: UserCollection.ID, request: InviteCollaboratorRequest) async throws {
        try await rest.collaboratorInvite(collectionId, request: request)
    }
}
