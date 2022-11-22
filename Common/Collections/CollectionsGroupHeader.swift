import SwiftUI
import API
import UI

struct CollectionsGroupHeader: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var action: CollectionActionsStore
    
    @FocusState private var askRename: Bool
    @State private var askRemove = false
    
    var group: CGroup
    
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
                    Button(action: collapseAll) {
                        Label("Expand/collapse all", systemImage: "chevron.down.square")
                    }
                    
                    Menu {
                        Button("By name (A-Z)") { sortAll(.titleAsc) }
                        Button("By name (Z-A)") { sortAll(.titleDesc) }
                        Button("By count") { sortAll(.countDesc) }
                    } label: {
                        Label("Sort all", systemImage: "textformat")
                    }
                    
                    Divider()
                    
                    Button(action: toggle) {
                        Label("Hide", systemImage: "eye.slash")
                    }
                    
                    Button {
                        askRename = true
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        askRemove = true
                    } label: {
                        Label("Remove", systemImage: "trash")
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
                .fontWeight(.medium)
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

