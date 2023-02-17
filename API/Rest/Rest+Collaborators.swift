import Foundation

//MARK: - Get
extension Rest {
    public func collaboratorsGet(_ collectionId: UserCollection.ID) async throws -> [Collaborator] {
        let res: ItemsResponse<Collaborator> = try await fetch.get("collection/\(collectionId)/sharing")
        return res.items
    }
}

//MARK: - Invite
extension Rest {
    public func collaboratorInvite(_ collectionId: UserCollection.ID, request: InviteCollaboratorRequest) async throws {
        let _: ResultResponse = try await fetch.post("collection/\(collectionId)/sharing", body: request)
    }
}

//MARK: - Change
extension Rest {
    public func collaboratorChange(_ collectionId: UserCollection.ID, userId: Collaborator.ID, level: CollectionAccess.Level) async throws {
        let _: ResultResponse = try await fetch.put("collection/\(collectionId)/sharing/\(userId)", body: CollaboratorChangeRequest(role: "\(level)"))
    }
    
    fileprivate struct CollaboratorChangeRequest: Encodable {
        var role: String
    }
}

//MARK: - Delete all
extension Rest {
    public func collaboratorsDeleteAll(_ collectionId: UserCollection.ID) async throws {
        try await fetch.delete("collection/\(collectionId)/sharing")
    }
}
