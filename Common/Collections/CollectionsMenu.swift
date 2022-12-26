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

    var ids: Set<Int>
    
    @ViewBuilder
    func user(_ ids: Set<Int>) -> some View {
        if !ids.isEmpty {
            if ids.count == 1, let id = ids.first {
                if let collection = c.state.user[id] {
                    //create
                    Button {
                        event.create(.parent(id))
                    } label: {
                        Label("Create collection", systemImage: "plus.rectangle.on.folder")
                    }
                    
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
            
            Button(role: .destructive) {
                event.delete(ids)
            } label: {
                Label("Delete", systemImage: "trash")
            }
                .tint(.red)
        }
    }
    
    var body: some View {
        user(ids.filter { $0 > 0 })
    }
}
