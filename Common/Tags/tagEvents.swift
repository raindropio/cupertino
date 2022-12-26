import SwiftUI
import API
import Combine

public extension View {
    func tagEvents() -> some View {
        modifier(TagEvents())
    }
}

struct TagEvents: ViewModifier {
    @StateObject private var event = TagEvent()
    
    @State private var rename: String?
    @State private var renaming = false
    @State private var merge: Set<String>?
    @State private var merging = false
    @State private var delete: Set<String>?
    @State private var deleting = false
    
    func body(content: Content) -> some View {
        content
            //receive events
            .environmentObject(event)
            .onReceive(event.rename) { rename = $0; renaming = true }
            .onReceive(event.merge) { merge = $0; merging = true }
            .onReceive(event.delete) { delete = $0; deleting = true }
            //alerts
            .alert("Rename", isPresented: $renaming, presenting: rename, actions: Rename.init)
            .alert("Merge", isPresented: $merging, presenting: merge, actions: Merge.init)
            .alert("Are you sure?", isPresented: $deleting, presenting: delete, actions: Delete.init)
    }
}

class TagEvent: ObservableObject {
    fileprivate let rename: PassthroughSubject<String, Never> = PassthroughSubject()
    fileprivate let merge: PassthroughSubject<Set<String>, Never> = PassthroughSubject()
    fileprivate let delete: PassthroughSubject<Set<String>, Never> = PassthroughSubject()
    
    func rename(_ tag: String) {
        rename.send(tag)
    }
    
    func merge(_ tags: Set<String>) {
        merge.send(tags)
    }
    
    func delete(_ tag: String) {
        delete.send([tag])
    }
    
    func delete(_ tags: Set<String>) {
        delete.send(tags)
    }
}

extension String: Identifiable {
    public var id: String { self }
}

extension Set: Identifiable where Element == String {
    public var id: String { self.map { $0 }.joined() }
}
