#if canImport(UIKit)
import SwiftUI
import UI
import API
import Features

extension Folder.Toolbar {
    struct Editing: ViewModifier {
        @IsEditing private var isEditing
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var pick: RaindropsPick
        var toggleAll: () -> Void
        
        func body(content: Content) -> some View {
            content
            .navigationBarBackButtonHidden(isEditing)
            .toolbar {
                if isEditing {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(pick.isAll ? "Deselect all" : "Select all", action: toggleAll)
                    }
                    
                    if !pick.isEmpty {
                        ToolbarItemGroup {
                            Menu {
                                RaindropsMenu(pick)
                            } label: {
                                Text("Actions")
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        if #available(iOS 26.0, *) {
                            ToolbarSpacer()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        EditButton {
                            Label("Done", systemImage: "checkmark")
                        }
                            .labelStyle(.toolbar)
                    }
                    
                    if #available(iOS 26.0, *) {
                        ToolbarSpacer()
                    }
                }
            }
        }
    }
}
#endif
