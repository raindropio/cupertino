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
}
