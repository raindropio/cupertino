#if canImport(UIKit)
import SwiftUI
import UI
import API
import Features

extension Folder.Toolbar {
    struct Editing: ViewModifier {
        @IsEditing private var isEditing
        @Environment(\.isSearching) private var isSearching
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var pick: RaindropsPick
        var total: Int
        var toggleAll: () -> Void
        
        func body(content: Content) -> some View {
            content
            .toolbar {
                if total > 0 {
                    ToolbarItemGroup(
                        placement: sizeClass == .regular ? .automatic : ( (isEditing || isSearching) ? .bottomBar : .secondaryAction )
                    ) {
                        if isEditing {
                            Button(pick.isAll ? "Deselect all" : "Select all", action: toggleAll)
                        }
                        
                        EditButton {
                            Label($0 == .active ? "Cancel" : "Select", systemImage: $0 == .active ? "xmark.circle" : "checkmark.circle")
                        }
                    }
                    
                    if !pick.isEmpty {
                        ToolbarItemGroup(placement: .status) {
                            if sizeClass == .compact {
                                Menu {
                                    RaindropsMenu(pick)
                                } label: {
                                    Text("Actions")
                                        .fontWeight(.semibold)
                                }
                            } else {
                                RaindropsMenu(pick)
                            }
                        }
                    }
                }
            }
        }
    }
}
#endif
