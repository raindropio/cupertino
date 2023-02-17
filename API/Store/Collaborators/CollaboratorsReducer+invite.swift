extension CollaboratorsReducer {
    func invite(state: inout S, collectionId: UserCollection.ID, request: InviteCollaboratorRequest) async throws {
        try await rest.collaboratorInvite(collectionId, request: request)
    }
}
