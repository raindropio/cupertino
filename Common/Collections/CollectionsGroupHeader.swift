import SwiftUI
import API
import UI
import Backport

struct CollectionsGroupHeader: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var action: CollectionActionsStore
    
    @FocusState private var askRename: Bool
    @State private var askRemove = false
    
    var group: CGroup
    var single = false
    
    func collapseAll() {
        dispatch.sync(CollectionsAction.toggleMany)
    }
    
    func sortAll(_ by: UpdateCollectionsRequest.Sort) {
        dispatch.sync(CollectionsAction.reorderMany(by))
    }
    
    func toggle() {
        dispatch.sync(CollectionsAction.toggleGroup(group))
    }
    
    func add() {
        action(.create(.group(group)))
    }
    
    func rename(_ title: String) {
        var group = group
        group.title = title
        dispatch.sync(CollectionsAction.renameGroup(group))
    }
    
    func remove() {
        dispatch.sync(CollectionsAction.deleteGroup(group))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            RenameField(
                "Group name",
                text: group.title,
                focused: $askRename,
                onSubmit: rename
            )
            
            Spacer()
            
            if !group.hidden {
                Menu {
                    Group {
                        Button(action: collapseAll) {
                            Label("Expand/collapse all", systemImage: "chevron.down.square")
                        }
                        
                        Menu {
                            Button("By name (A-Z)") { sortAll(.titleAsc) }
                            Button("By name (Z-A)") { sortAll(.titleDesc) }
                            Button("By count") { sortAll(.countDesc) }
                        } label: {
                            Label("Sort all", systemImage: "arrow.up.arrow.down")
                        }
                    }
                        .disabled(group.collections.isEmpty)
                    
                    if !single {
                        Divider()
                        
                        Button(action: toggle) {
                            Label("Hide group", systemImage: "eye.slash")
                        }
                        
                        Button {
                            askRename = true
                        } label: {
                            Label("Rename group", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            askRemove = true
                        } label: {
                            Label("Delete group", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 44)
                        .frame(maxHeight: .infinity)
                }
                    .foregroundColor(.secondary)
            }
                        
            Button(action: group.hidden ? toggle : add) {
                Image(systemName: group.hidden ? "minus" : "plus")
                    .padding(.leading, 12)
                    #if os(macOS)
                    .padding(.trailing, 16)
                    #endif
            }
                .backport.fontWeight(.semibold)
        }
            .buttonStyle(.borderless)
            .menuIndicator(.hidden)
            .imageScale(.large)
            //remove
            .confirmationDialog(
                group.collections.isEmpty ? "Are you sure?" : "Group should be empty!",
                isPresented: $askRemove,
                titleVisibility: .visible
            ) {
                Button(role: .destructive, action: remove) {
                    Text("Remove \"\(group.title)\" group")
                }
                    .disabled(!group.collections.isEmpty)
            }
    }
}

