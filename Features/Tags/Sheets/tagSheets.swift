import SwiftUI
import API
import Combine

public extension View {
    func tagSheets() -> some View {
        modifier(_TagSheetsModifier())
    }
}

struct _TagSheetsModifier: ViewModifier {
    @StateObject private var sheet = TagSheet()
    
    @State private var rename: String?
    @State private var renaming = false
    @State private var merge: Set<String>?
    @State private var merging = false
    @State private var delete: Set<String>?
    @State private var deleting = false
    
    func body(content: Content) -> some View {
        content
            .environmentObject(sheet)
            .onReceive(sheet.rename) { rename = $0; renaming = true }
            .onReceive(sheet.merge) { merge = $0; merging = true }
            .onReceive(sheet.delete) { delete = $0; deleting = true }
            //alerts
            .alert("Rename", isPresented: $renaming, presenting: rename, actions: Rename.init)
            .alert("Merge", isPresented: $merging, presenting: merge, actions: Merge.init)
            .alert("Are you sure?", isPresented: $deleting, presenting: delete, actions: Delete.init)
    }
}

class TagSheet: ObservableObject {
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

extension Set: Identifiable where Element == String {
    public var id: String { self.map { $0 }.joined() }
}
