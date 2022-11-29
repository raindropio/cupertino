import SwiftUI
import API

public extension View {
    func collectionActions() -> some View {
        modifier(CollectionActions())
    }
}

struct CollectionActions: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @StateObject private var service = CollectionActionsStore()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(service)
            //reset
            .onAppear {
                service(nil)
            }
            //create
            .sheet(item: $service.createItem, content: CollectionStack.init)
            //edit
            .sheet(item: $service.editItem, content: CollectionStack.init)
            //delete
            .confirmationDialog(
                "Are you sure?",
                isPresented: $service.deletePresented,
                presenting: service.deleteItem
            ) { collection in
                Button(role: .destructive) {
                    dispatch.sync(CollectionsAction.delete(collection.id))
                } label: {
                    Text("Delete \(collection.title)")
                }
            }
    }
}

//MARK: - Helpers
fileprivate extension CollectionActionsStore {
    var createItem: CollectionStack.NewLocation? {
        get {
            if case .create(let location) = self.ask {
                return location
            }
            return nil
        }
        set {
            callAsFunction(newValue != nil ? .create(newValue!) : nil)
        }
    }
    
    var editItem: UserCollection? {
        get {
            if case .edit(let collection) = self.ask {
                return collection
            }
            return nil
        }
        set {
            callAsFunction(newValue != nil ? .edit(newValue!) : nil)
        }
    }
    
    var deletePresented: Bool {
        get {
            if case .delete(_) = self.ask {
                return true
            }
            return false
        }
        set {
            if !newValue {
                callAsFunction(nil)
            }
        }
    }
    
    var deleteItem: UserCollection? {
        get {
            if case .delete(let collection) = self.ask {
                return collection
            }
            return nil
        }
        set {
            callAsFunction(newValue != nil ? .delete(newValue!) : nil)
        }
    }
}
