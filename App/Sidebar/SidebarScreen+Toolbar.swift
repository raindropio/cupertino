import SwiftUI
import API
import UI
import Features

extension SidebarScreen {
    struct Toolbar: ViewModifier {
        @EnvironmentObject private var app: AppRouter
        @EnvironmentObject private var settings: SettingsRouter
        @Environment(\.editMode) private var editMode
        
        @Binding var selection: Set<FindBy>

        func body(content: Content) -> some View {
            content
            .meNavigationTitle()
            .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        settings.open()
                    } label: {
                        MeLabel()
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItemGroup {
                    if editMode?.wrappedValue != .active {
                        Button {
                            app.spotlight = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        
                        Menu {
                            EditButton("Select")
                            
                            Section { CollectionsMenu() }
                            Section { TagsMenu() }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    } else {
                        EditButton()
                    }
                }
                
                //edit mode
                ToolbarItemGroup(placement: .bottomBar) {
                    if !selection.isEmpty, editMode?.wrappedValue == .active {
                        Group {
                            if selection.allSatisfy({ !$0.isSearching }) {
                                CollectionsMenu(selection)
                            } else if selection.allSatisfy({ $0.isSearching }) {
                                TagsMenu(selection)
                            }
                        }
                            .labelStyle(.titleOnly)
                    }
                }
            }
        }
    }
}
