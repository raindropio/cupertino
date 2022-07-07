import SwiftUI
import API

struct TreeMenu: View {
    var selection: Set<Collection>
    @Environment(\.treeAction) private var action
    
    var body: some View {
        #if os(iOS)
        Button(action: {}) {
            Label("Select", systemImage: "checkmark.circle")
        }
        #endif
        
        Button(action: { action.wrappedValue = .edit(selection.first!) }) {
            Label("Edit", systemImage: "pencil")
        }
            .disabled(selection.count != 1)
        
        Button(action: { action.wrappedValue = .delete(selection) }) {
            Label("Delete", systemImage: "trash")
        }
    }
}
