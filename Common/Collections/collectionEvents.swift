import SwiftUI
import API
import Combine

public extension View {
    func collectionEvents() -> some View {
        modifier(CollectionEvents())
    }
}

fileprivate struct CollectionEvents: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @StateObject private var event = CollectionEvent()
    
    @State private var create: CollectionStack.NewLocation?
    @State private var edit: UserCollection?
    @State private var delete: UserCollection.ID?
    @State private var deleting = false
    
    func body(content: Content) -> some View {
        content
            //receive events
            .environmentObject(event)
            .onReceive(event.create) { create = $0 }
            .onReceive(event.edit) { edit = $0 }
            .onReceive(event.delete) { delete = $0; deleting = true }
            //sheets
            .sheet(item: $create, content: CollectionStack.init)
            .sheet(item: $edit, content: CollectionStack.init)
            .alert("Are you sure?", isPresented: $deleting, presenting: delete) { id in
                Button("Delete collection", role: .destructive) {
                    dispatch.sync(CollectionsAction.delete(id))
                }
            } message: { _ in
                Text("This action will delete collection and all nested collections.\nBookmarks will be moved to Trash.")
            }
    }
}

class CollectionEvent: ObservableObject {
    fileprivate let create: PassthroughSubject<CollectionStack.NewLocation, Never> = PassthroughSubject()
    fileprivate let edit: PassthroughSubject<UserCollection, Never> = PassthroughSubject()
    fileprivate let delete: PassthroughSubject<UserCollection.ID, Never> = PassthroughSubject()

    func create(_ location: CollectionStack.NewLocation) {
        create.send(location)
    }
    
    func edit(_ collection: UserCollection) {
        edit.send(collection)
    }
    
    func delete(_ id: UserCollection.ID) {
        delete.send(id)
    }
}
