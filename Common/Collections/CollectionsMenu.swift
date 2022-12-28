import SwiftUI
import API

public func CollectionsMenu(_ id: Int) -> some View {
    _CollectionsMenu(ids: [id])
}

public func CollectionsMenu(_ ids: Set<Int>) -> some View {
    _CollectionsMenu(ids: ids)
}

public func CollectionsMenu(_ ids: Set<FindBy>) -> some View {
    _CollectionsMenu(ids: .init(
        ids.compactMap {
            $0.isSearching ? nil : $0.collectionId
        })
    )
}

fileprivate struct _CollectionsMenu: View {
    @EnvironmentObject private var c: CollectionsStore
    @EnvironmentObject private var event: CollectionEvent
    @EnvironmentObject private var dispatch: Dispatcher

    var ids: Set<Int>
    
    @ViewBuilder
    func new(_ ids: Set<Int>) -> some View {
        if ids.count == 1, let id = ids.first, id > 0 {
            Button { event.create(.parent(id)) } label: {
                Label("Add", systemImage: "plus.rectangle.on.folder")
            }
        } else if ids.first(where: { $0 <= 0 }) == nil {
            Button { event.create(.group()) } label: {
                Label("New", systemImage: "plus.rectangle.on.folder")
            }
        }
    }
    
    @ViewBuilder
    func bulk(_ ids: Set<Int>) -> some View {
        if ids.isEmpty {
            Button { dispatch.sync(CollectionsAction.toggleMany) } label: {
                Label(c.state.allCollapsed ? "Expand all" : "Collapse all", systemImage: "folder.badge.gearshape")
            }
            
            Menu {
                Button("By name") { dispatch.sync(CollectionsAction.reorderMany(.titleAsc)) }
                Button("By count") { dispatch.sync(CollectionsAction.reorderMany(.countDesc)) }
            } label: {
                Label("Sort collections", systemImage: "folder")
            }
        }
    }
    
    @ViewBuilder
    func user(_ ids: Set<Int>) -> some View {
        if ids.count == 1, let id = ids.first {
            if let collection = c.state.user[id] {
                //edit
                Button {
                    event.edit(collection)
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        
        //merge
        if ids.count > 1 {
            Button {
                event.merge(ids)
            } label: {
                Label("Merge", systemImage: "arrow.triangle.merge")
            }
        }
            
        if !ids.isEmpty {
            Button(role: .destructive) {
                event.delete(ids)
            } label: {
                Label("Delete", systemImage: "trash")
            }
                .tint(.red)
        }
    }
    
    var body: some View {
        new(ids)
        bulk(ids)
        user(ids.filter { $0 > 0 })
    }
}
