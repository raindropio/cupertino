import SwiftUI
import Combine
import UI
import API

public extension View {
    func raindropsEvent(
        onPress: @escaping (RaindropsEventPressed) -> Void
    ) -> some View {
        modifier(_Modifier(onPress: onPress))
    }
}

fileprivate struct _Modifier: ViewModifier {
    @Environment(\.editMode) private var editMode
    @StateObject private var event = RaindropsEvent()
    @State private var edit: Raindrop.ID?
    @State private var move: RaindropsPick?
    @State private var addTags: RaindropsPick?
    @State private var delete: RaindropsPick?
    @State private var deleting = false

    var onPress: (RaindropsEventPressed) -> Void
    
    func body(content: Content) -> some View {
        content
        //receive
        .environmentObject(event)
        .onReceive(event.pressed, perform: onPress)
        .onReceive(event.edit) { edit = $0 }
        .onReceive(event.move) { move = $0 }
        .onReceive(event.addTags) { addTags = $0 }
        .onReceive(event.delete) { delete = $0; deleting = true }
        //sheets/alerts
        .sheet(item: $edit) { id in
            RaindropStack(id, content: RaindropForm.init)
        }
        .sheet(item: $move) { pick in
            NavigationStack {
                MoveRaindrops(pick: pick)
            }
        }
        .sheet(item: $addTags) { pick in
            NavigationStack {
                AddTagsRaindrops(pick: pick)
            }
        }
        .alert("Are you sure?", isPresented: $deleting, presenting: delete, actions: DeleteRaindrops.init) { _ in
            Text("Bookmarks will be moved to Trash")
        }
    }
}

class RaindropsEvent: ObservableObject {
    fileprivate let pressed: PassthroughSubject<RaindropsEventPressed, Never> = PassthroughSubject()
    fileprivate let edit: PassthroughSubject<Raindrop.ID, Never> = PassthroughSubject()
    fileprivate let move: PassthroughSubject<RaindropsPick, Never> = PassthroughSubject()
    fileprivate let addTags: PassthroughSubject<RaindropsPick, Never> = PassthroughSubject()
    fileprivate let delete: PassthroughSubject<RaindropsPick, Never> = PassthroughSubject()
    
    func press(_ of: RaindropsEventPressed) {
        self.pressed.send(of)
    }
    
    func open(_ id: Raindrop.ID) {
        press(.open(id))
    }
    
    func edit(_ id: Raindrop.ID) {
        edit.send(id)
    }
    
    func move(_ pick: RaindropsPick) {
        move.send(pick)
    }
    
    func addTags(_ pick: RaindropsPick) {
        addTags.send(pick)
    }
    
    func delete(_ pick: RaindropsPick) {
        delete.send(pick)
    }
}

public enum RaindropsEventPressed {
    case open(Raindrop.ID)
    case preview(Raindrop.ID)
    case cache(Raindrop.ID)
    case collection(Int)
}
