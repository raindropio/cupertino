import SwiftUI
import API
import Combine

public extension View {
    func collectionSheets() -> some View {
        modifier(_CollectionSheetsModifier())
    }
}

struct _CollectionSheetsModifier: ViewModifier {
    @StateObject private var sheet = CollectionSheet()
    
    @State private var create: UserCollection?
    @State private var edit: UserCollection?
    @State private var share: UserCollection?
    @State private var merge: Set<UserCollection.ID> = .init()
    @State private var merging = false
    @State private var delete: Set<UserCollection.ID> = .init()
    @State private var deleting = false
    @State private var groupEdit: CGroup?
    @State private var groupEditing = false
    @State private var groupDelete: CGroup?
    @State private var groupDeleting = false
    
    func body(content: Content) -> some View {
        content
            //receive sheets
            .environmentObject(sheet)
            .onReceive(sheet.create) { create = .new(parent: $0) }
            .onReceive(sheet.edit) { edit = $0 }
            .onReceive(sheet.share) { share = $0 }
            .onReceive(sheet.merge) { merge = $0; merging = true }
            .onReceive(sheet.delete) { delete = $0; deleting = true }
            .onReceive(sheet.groupEdit) { groupEdit = $0; groupEditing = true }
            .onReceive(sheet.groupDelete) { groupDelete = $0; groupDeleting = true }
            //sheets/alerts
            .sheet(item: $create) {
                CollectionStack($0, content: CollectionForm.init)
                    .frame(idealWidth: 400, idealHeight: 400)
            }
            .sheet(item: $edit) {
                CollectionStack($0, content: CollectionForm.init)
                    .frame(idealWidth: 400, idealHeight: 400)
            }
            .sheet(item: $share) {
                CollectionStack($0, content: CollectionSharing.init)
                    .frame(idealWidth: 400, idealHeight: 400)
            }
            .alert("Are you sure?", isPresented: $merging, presenting: merge, actions: Merge.init)
            .alert("Are you sure?", isPresented: $deleting, presenting: delete, actions: Delete.init) { _ in
                Text("Items will be moved to Trash")
            }
            //group
            .alert("Rename group", isPresented: $groupEditing, presenting: groupEdit, actions: GroupEdit.init)
            .alert("Are you sure?", isPresented: $groupDeleting, presenting: groupDelete, actions: GroupDelete.init)
    }
}

public class CollectionSheet: ObservableObject {
    fileprivate let create: PassthroughSubject<UserCollection.ID?, Never> = PassthroughSubject()
    fileprivate let edit: PassthroughSubject<UserCollection, Never> = PassthroughSubject()
    fileprivate let share: PassthroughSubject<UserCollection, Never> = PassthroughSubject()
    fileprivate let merge: PassthroughSubject<Set<UserCollection.ID>, Never> = PassthroughSubject()
    fileprivate let delete: PassthroughSubject<Set<UserCollection.ID>, Never> = PassthroughSubject()
    fileprivate let groupEdit: PassthroughSubject<CGroup, Never> = PassthroughSubject()
    fileprivate let groupDelete: PassthroughSubject<CGroup, Never> = PassthroughSubject()

    public func create(_ parent: UserCollection.ID? = nil) {
        create.send(parent)
    }
    
    func edit(_ collection: UserCollection) {
        edit.send(collection)
    }
    
    func share(_ collection: UserCollection) {
        share.send(collection)
    }
    
    func edit(_ group: CGroup) {
        groupEdit.send(group)
    }
    
    func merge(_ ids: Set<UserCollection.ID>) {
        merge.send(ids)
    }
    
    func delete(_ ids: Set<UserCollection.ID>) {
        delete.send(ids)
    }
    
    func delete(_ group: CGroup) {
        groupDelete.send(group)
    }
}
