import SwiftUI
import API
import Combine

public extension View {
    func tagEvents() -> some View {
        modifier(TagEvents())
    }
}

fileprivate struct TagEvents: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @StateObject private var event = TagEvent()
    
    @State private var rename: String?
    @State private var merge: Set<String>?
    @State private var delete: Set<String>?
    @State private var deleting = false
    
    func body(content: Content) -> some View {
        content
            //receive events
            .environmentObject(event)
            .onReceive(event.rename) { rename = $0 }
            .onReceive(event.merge) { merge = $0 }
            .onReceive(event.delete) { delete = $0; deleting = true }
            //sheets
            .sheet(item: $rename, content: TagRenameStack.init)
            .sheet(item: $merge, content: TagsMergeStack.init)
            .alert("Are you sure?", isPresented: $deleting, presenting: delete) { tags in
                Button("Delete \(tags.count) tags", role: .destructive) {
                    dispatch.sync(FiltersAction.delete(
                        .init(
                            tags.map { .init(.tag($0)) }
                        )
                    ))
                }
            }
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
