#if canImport(UIKit)
import SwiftUI
import UI
import API
import Features

extension Folder.Toolbar {
    struct Editing: ViewModifier {
        @Environment(\.editMode) private var editMode
        @Environment(\.isSearching) private var isSearching
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var pick: RaindropsPick
        var toggleAll: () -> Void
        
        private var isActive: Bool {
            editMode?.wrappedValue == .active
        }
        
        private var editButtonPlacement: ToolbarItemPlacement {
            if isSearching, sizeClass == .compact {
                return .status
            }
            return editMode?.wrappedValue == .active ? .cancellationAction : .automatic
        }
        
        private var selectAllButtonPlacement: ToolbarItemPlacement {
            if isSearching, sizeClass == .compact {
                return .status
            }
            return .primaryAction
        }
        
        func body(content: Content) -> some View {
            content
            .navigationBarBackButtonHidden(editMode?.wrappedValue == .active)
            .toolbar {
                //start/cancel
                ToolbarItem(placement: editButtonPlacement) {
                    EditButton {
                        if $0 == .active {
                            Text("Cancel")
                        } else {
                            Label("Select", systemImage: "checkmark.circle")
                        }
                    }
                }
                
                //edit mode
                if isActive {
                    //select/deselect all
                    ToolbarItem(placement: selectAllButtonPlacement) {
                        Button(action: toggleAll) {
                            Label(
                                pick.isAll ? "Deselect all" : "Select all",
                                systemImage: pick.isAll ? "checklist.unchecked" : "checklist.checked"
                            )
                        }
                            .labelStyle(.titleOnly)
                    }
                    
                    //actions
                    ToolbarItemGroup(placement: .bottomBar) {
                        RaindropsMenu(pick)
                    }
                }
            }
        }
    }
}
#endif
