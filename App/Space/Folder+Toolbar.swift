import SwiftUI
import UI
import API
import Features

extension Folder {
    struct Toolbar: ViewModifier {
        @EnvironmentObject private var r: RaindropsStore
        
        var find: FindBy
        @Binding var selection: Set<Raindrop.ID>

        func body(content: Content) -> some View {
            content.modifier(Memorized(
                find: find,
                selection: $selection,
                ids: r.state.items(find).map { $0.id }
            ))
        }
    }
}

extension Folder.Toolbar {
    fileprivate struct Memorized: ViewModifier {
        @Environment(\.editMode) private var editMode
        @Environment(\.isSearching) private var isSearching
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @EnvironmentObject private var app: AppRouter

        var find: FindBy
        @Binding var selection: Set<Raindrop.ID>
        var ids: [Raindrop.ID]
        
        private var pick: RaindropsPick {
            selection.count == ids.count ? .all(find): .some(selection)
        }
        
        private var cancelEditModeButton: some View {
            Button("Cancel", role: .cancel) {
                withAnimation {
                    editMode?.wrappedValue = .inactive
                }
            }
        }
        
        private var selectAllButton: some View {
            Button {
                selection = .init(pick.isAll ? [] : ids)
            } label: {
                Label(
                    pick.isAll ? "Deselect all" : "Select all",
                    systemImage: pick.isAll ? "checklist.unchecked" : "checklist.checked"
                )
            }
        }
        
        func body(content: Content) -> some View {
            content
            .toolbarRole(.browser)
            .navigationBarBackButtonHidden(editMode?.wrappedValue == .active)
            .toolbar {
                //edit mode
                if editMode?.wrappedValue == .active {
                    ToolbarItem {
                        selectAllButton
                            .labelStyle(.titleOnly)
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        cancelEditModeButton
                            .fontWeight(.semibold)
                    }
                    
                    ToolbarItem(placement: .status) {
                        Menu {
                            selectAllButton
                            
                            Section {
                                cancelEditModeButton
                            }
                        } label: {
                            (Text("\(selection.count) selected ") + Text(Image(systemName: "chevron.up.chevron.down")))
                                .imageScale(.small)
                        }
                            .tint(.primary)
                            .lineLimit(1)
                            .layoutPriority(-1)
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        RaindropsMenu(pick)
                    }
                }
                //regular
                else {
                    ToolbarItemGroup {
                        if sizeClass == .regular {
                            SortRaindropsButton(find)
                            CustomizeRaindropsButton(find)
                        }
                        
                        if sizeClass == .compact {
                            Button {
                                app.search()
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                        } else {
                            EditButton("Select")
                        }
                        
                        //more
                        Menu {
                            if sizeClass == .compact {
                                EditButton("Select")
                            }
                            
                            Section {
                                CollectionsMenu(find.collectionId)
                            }
                        } label: {
                            Label("Edit collection", systemImage: "ellipsis")
                        }
                    }
                    
                    if isSearching, sizeClass == .compact {
                        ToolbarItemGroup(placement: .status) {
                            EditButton("Select")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }
            }
        }
    }
}
