import SwiftUI
import API

public func CollectionsMenu() -> some View {
    _CollectionsMenu(ids: [])
}

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
    @EnvironmentObject private var sheet: CollectionSheet
    @EnvironmentObject private var dispatch: Dispatcher

    var ids: Set<Int>
    
    @ViewBuilder
    func new(_ ids: Set<Int>) -> some View {
        if ids.isEmpty {
            Button { sheet.create() } label: {
                Label("New collection", systemImage: "plus")
            }
        }
        else if ids.count == 1, let id = ids.first, id > 0 {
            Button { sheet.create(id) } label: {
                Label("Add collection", systemImage: "plus.square.dashed")
            }
        }
    }
    
    @ViewBuilder
    func bulk(_ ids: Set<Int>) -> some View {
        if ids.isEmpty {
            Button { dispatch.sync(CollectionsAction.toggleMany) } label: {
                if c.state.allCollapsed {
                    Label("Expand all", systemImage: "list.bullet.indent")
                } else {
                    Label("Collapse all", systemImage: "list.bullet")
                }
            }
            
            Menu {
                Button("By name") { dispatch.sync(CollectionsAction.reorderMany(.titleAsc)) }
                Button("By count") { dispatch.sync(CollectionsAction.reorderMany(.countDesc)) }
            } label: {
                Label("Sort collections", systemImage: "arrow.up.arrow.down.square")
            }
        }
    }
    
    @ViewBuilder
    func user(_ ids: Set<Int>) -> some View {
        if ids.count == 1, let id = ids.first {
            if let collection = c.state.user[id] {
                //edit
                Button {
                    sheet.edit(collection)
                } label: {
                    Label("Edit collection", systemImage: "pencil")
                }
                
                //share
                Button {
                    sheet.share(collection)
                } label: {
                    Label("Share collection", systemImage: "square.and.arrow.up")
                }
            }
        }
        
        //merge
        if ids.count > 1 {
            Button {
                sheet.merge(ids)
            } label: {
                Label("Merge collections", systemImage: "arrow.triangle.merge")
            }
        }
            
        if !ids.isEmpty {
            Button(role: .destructive) {
                sheet.delete(ids)
            } label: {
                Label("Delete collection", systemImage: "trash")
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
