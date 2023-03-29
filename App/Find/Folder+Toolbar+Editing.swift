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
            .navigationBarBackButtonHidden(isEditing)
            .toolbar {
                if total > 0 {
                    //start/cancel
                    ToolbarItem(placement: isEditing ? .cancellationAction : .automatic) {
                        EditButton {
                            if $0 == .active {
                                Text("Cancel")
                            } else {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                    
                    //edit mode
                    if isEditing {
                        //select/deselect all
                        ToolbarItem(placement: sizeClass == .compact ? .bottomBar : .primaryAction) {
                            Button(pick.isAll ? "Deselect all" : "Select all", action: toggleAll)
                        }
                        
                        //actions
                        ToolbarItemGroup(placement: .bottomBar) {
                            RaindropsMenu(pick)
                        }
                    }
                }
            }
            //special case for iphone searching
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                if sizeClass == .compact, total > 0, isSearching, find.isSearching {
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        withAnimation { isEditing = !isEditing }
                    } label: {
                        Image(systemName: isEditing ? "xmark" : "checkmark.circle.fill")
                            .imageScale(.large)
                    }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .scenePadding()
                }
            }
        }
    }
}
#endif
