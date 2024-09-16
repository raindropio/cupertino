import SwiftUI

extension CollaboratorsReducer {
    func invite(state: S, collectionId: UserCollection.ID, request: InviteCollaboratorRequest, link: Binding<URL?>) async throws {
        link.wrappedValue = try await rest.collaboratorInvite(collectionId, request: request)
    }
}
