import SwiftUI
import API

extension BrowseBulk {
    struct ToggleAll: View {
        @EnvironmentObject private var r: RaindropsStore
                
        var find: FindBy
        @Binding var selection: Set<Raindrop.ID>
        
        private var isAllSelected: Bool {
            selection.count == r.state.items(find).count
        }
        
        var body: some View {
            Button {
                if isAllSelected {
                    selection = .init()
                } else {
                    selection = .init( r.state.items(find).map { $0.id } )
                }
            } label: {
                if isAllSelected {
                    Label("Deselect All", systemImage: "checklist.unchecked")
                } else {
                    Label("Select All", systemImage: "checklist.checked")
                }
            }
        }
    }
}
