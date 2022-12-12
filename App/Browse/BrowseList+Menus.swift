import SwiftUI
import API
import UI
import Backport

extension BrowseList {
    struct Menus: View {
        @EnvironmentObject private var r: RaindropsStore
        var ids: Set<Raindrop.ID>
        @Binding var selection: Set<Raindrop.ID>
        @Binding var edit: Raindrop?
        
        var body: some View {
            Memorized(
                items: ids.compactMap(r.state.item),
                selection: $selection,
                edit: $edit
            )
        }
    }
}

extension BrowseList.Menus {
    struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var app: AppRouter
        @Environment(\.editMode) private var editMode
        
        var items: [Raindrop]
        @Binding var selection: Set<Raindrop.ID>
        @Binding var edit: Raindrop?
        
        var body: some View {
            if items.count == 1, let item = items.first {
                Section {
                    Link(destination: item.link) {
                        Label("Open", systemImage: "safari")
                    }
                    
                    Button {
                        app.preview(item.id)
                    } label: {
                        Label("Preview", systemImage: "eyeglasses")
                    }
                    
                    Button {
                        app.preview(item.id, .cache)
                    } label: {
                        Label("Permanent copy", systemImage: "clock.arrow.circlepath")
                    }
                }
                
                Button {
                    withAnimation {
                        editMode?.wrappedValue = .active
                        selection.insert(item.id)
                    }
                } label: {
                    Label("Select", systemImage: "checkmark.circle")
                }
                                
                Section {
                    Button { edit = item } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Backport.ShareLink(item: item.link)

                    Button(role: .destructive) {
                        dispatch.sync(RaindropsAction.delete(item.id))
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}
