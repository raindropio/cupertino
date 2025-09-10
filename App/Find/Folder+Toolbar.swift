import SwiftUI
import UI
import API
import Features

extension Folder {
    struct Toolbar: ViewModifier {
        @EnvironmentObject private var r: RaindropsStore
        
        @Binding var find: FindBy
        @Binding var selection: Set<Raindrop.ID>
        
        private var pick: RaindropsPick {
            selection.count == r.state.ids(find).count ? .all(find): .some(selection)
        }
        
        private func toggleAll() {
            selection = .init(pick.isAll ? [] : r.state.ids(find))
        }

        func body(content: Content) -> some View {
            content
                .modifier(
                    Regular(find: $find, pick: pick, total: r.state.total(find))
                )
                .modifier(
                    Editing(find: find, pick: pick, toggleAll: toggleAll)
                )
                .raindropCommands(pick)
        }
    }
}

