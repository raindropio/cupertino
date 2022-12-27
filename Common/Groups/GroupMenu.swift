import SwiftUI
import API
import UI
import Backport

struct GroupMenu: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var event: CollectionEvent
    
    var group: CGroup
    
    func sortAll(_ by: UpdateCollectionsRequest.Sort) {
        dispatch.sync(CollectionsAction.reorderMany(by))
    }
    
    var body: some View {
        Group {
            Button {
                dispatch.sync(CollectionsAction.toggleMany)
            } label: {
                Label("Expand/collapse all", systemImage: "chevron.down.square")
            }
            
            Button {
                sortAll(.titleAsc)
            } label: {
                Label("Sort all by name", systemImage: "textformat.superscript")
            }
            
            Button {
                sortAll(.countDesc)
            } label: {
                Label("Sort all by count", systemImage: "list.number")
            }

            Divider()
        }
            .disabled(group.collections.isEmpty)
        
        Button {
            event.edit(group)
        } label: {
            Label("Rename group", systemImage: "pencil")
        }
        
        Button(role: .destructive) {
            event.delete(group)
        } label: {
            Label("Delete group", systemImage: "trash")
        }
    }
}
