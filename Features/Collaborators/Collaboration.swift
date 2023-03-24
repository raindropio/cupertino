import SwiftUI
import API
import UI

struct Collaboration: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Binding var collection: UserCollection
    
    var body: some View {
        Section {
            Collaborators(collection: $collection)
        } header: {
            HStack {
                Text("Collaboration")
                
                Spacer()
                
                NavigationLink {
                    InviteCollaborator(collection: $collection)
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .fontWeight(.medium)
                }
            }
        } footer: {
            Text("Work together on collections privately with colleagues, friends and family. [Learn more](https://help.raindrop.io/collaboration/)")
                .openLinksInSafari()
        }
            .task(id: collection.id) {
                try? await dispatch(CollaboratorsAction.load(collection.id))
            }
    }
}
