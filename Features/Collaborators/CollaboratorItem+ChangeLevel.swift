import SwiftUI
import API
import UI

extension CollaboratorItem {
    struct ChangeLevel: View {
        @EnvironmentObject private var dispatch: Dispatcher
        var collection: UserCollection
        var collaborator: Collaborator
        
        private func change(level: CollectionAccess.Level) async throws {
            try await dispatch(CollaboratorsAction.change(collection.id, userId: collaborator.id, level: level))
        }
        
        var body: some View {
            switch collaborator.level {
            case .member, .viewer:
                Menu {
                    ActionButton {
                        try await change(level: .member)
                    } label: {
                        Label(CollectionAccess.Level.member.title, systemImage: collaborator.level == .member ? "checkmark" : "")
                    }
                    
                    ActionButton {
                        try await change(level: .viewer)
                    } label: {
                        Label(CollectionAccess.Level.viewer.title, systemImage: collaborator.level == .viewer ? "checkmark" : "")
                    }
                    
                    Menu("Unshare") {
                        Button("Confirm", role: .destructive) {
                            Task { try await change(level: .noAccess) }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(collaborator.level.title)
                        Image(systemName: "chevron.up.chevron.down")
                            .imageScale(.small)
                    }
                    .foregroundStyle(.tint)
                }
                
            default:
                Text(collaborator.level.title)
            }
        }
    }
}
