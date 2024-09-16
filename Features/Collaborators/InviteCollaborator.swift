import SwiftUI
import API
import UI

struct InviteCollaborator: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var link: URL?
    
    @Binding var collection: UserCollection
    
    var body: some View {
        Form {
            if let link {
                EmptyState(
                    "Share invitation link",
                    message: Text("Share this link with the person you want to invite to the collection.\n\nPlease note, this link can only be used once and will expire in a week.")
                ) {
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(.green)
                } actions: {
                    ShareLink(item: link)
                }
            } else {
                ActionButton(CollectionAccess.Level.member.title) {
                    try await dispatch(CollaboratorsAction.invite(collection.id, .init(level: .member), link: $link))
                }
                
                ActionButton(CollectionAccess.Level.viewer.title) {
                    try await dispatch(CollaboratorsAction.invite(collection.id, .init(level: .viewer), link: $link))
                }
            }
        }
            .navigationTitle("Invite")
            .animation(.default, value: link)
    }
}
