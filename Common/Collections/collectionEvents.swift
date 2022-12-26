import SwiftUI
import API
import Combine

public extension View {
    func collectionEvents() -> some View {
        modifier(CollectionEvents())
    }
}

struct CollectionEvents: ViewModifier {
    @StateObject private var event = CollectionEvent()
    
    @State private var create: CollectionStack.NewLocation?
    @State private var edit: UserCollection?
    @State private var merge: Set<UserCollection.ID> = .init()
    @State private var merging = false
    @State private var delete: Set<UserCollection.ID> = .init()
    @State private var deleting = false
    
    func body(content: Content) -> some View {
        content
            //receive events
            .environmentObject(event)
            .onReceive(event.create) { create = $0 }
            .onReceive(event.edit) { edit = $0 }
            .onReceive(event.merge) { merge = $0; merging = true }
            .onReceive(event.delete) { delete = $0; deleting = true }
            //sheets/alerts
            .sheet(item: $create, content: CollectionStack.init)
            .sheet(item: $edit, content: CollectionStack.init)
            .alert("Are you sure?", isPresented: $merging, presenting: merge, actions: Merge.init)
            .alert("Are you sure?", isPresented: $deleting, presenting: delete, actions: Delete.init) { _ in
                Text("Bookmarks will be moved to Trash")
            }
    }
}

class CollectionEvent: ObservableObject {
    fileprivate let create: PassthroughSubject<CollectionStack.NewLocation, Never> = PassthroughSubject()
    fileprivate let edit: PassthroughSubject<UserCollection, Never> = PassthroughSubject()
    fileprivate let merge: PassthroughSubject<Set<UserCollection.ID>, Never> = PassthroughSubject()
    fileprivate let delete: PassthroughSubject<Set<UserCollection.ID>, Never> = PassthroughSubject()

    func create(_ location: CollectionStack.NewLocation) {
        create.send(location)
    }
    
    func edit(_ collection: UserCollection) {
        edit.send(collection)
    }
    
    func merge(_ ids: Set<UserCollection.ID>) {
        merge.send(ids)
    }
    
    func delete(_ ids: Set<UserCollection.ID>) {
        delete.send(ids)
    }
}
