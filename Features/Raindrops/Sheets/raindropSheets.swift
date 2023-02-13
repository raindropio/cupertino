import SwiftUI
import Combine
import UI
import API

public extension View {
    func raindropSheets() -> some View {
        modifier(_Modifier())
    }
}

fileprivate struct _Modifier: ViewModifier {
    @Environment(\.editMode) private var editMode
    @StateObject private var sheet = RaindropSheet()
    @State private var edit: Raindrop.ID?
    @State private var move: RaindropsPick?
    @State private var addTags: RaindropsPick?
    @State private var delete: RaindropsPick?
    @State private var deleting = false
    
    func body(content: Content) -> some View {
        content
        //receive
        .environmentObject(sheet)
        .onReceive(sheet.edit) { edit = $0 }
        .onReceive(sheet.move) { move = $0 }
        .onReceive(sheet.addTags) { addTags = $0 }
        .onReceive(sheet.delete) { delete = $0; deleting = true }
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

class RaindropSheet: ObservableObject {
    fileprivate let edit: PassthroughSubject<Raindrop.ID, Never> = PassthroughSubject()
    fileprivate let move: PassthroughSubject<RaindropsPick, Never> = PassthroughSubject()
    fileprivate let addTags: PassthroughSubject<RaindropsPick, Never> = PassthroughSubject()
    fileprivate let delete: PassthroughSubject<RaindropsPick, Never> = PassthroughSubject()
    
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
