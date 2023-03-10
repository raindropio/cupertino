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
                total: r.state.total(find),
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
        var total: Int
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
            .toolbarTitleMenu {
                if !find.isSearching {
                    Section {
                        CollectionsMenu(find.collectionId)
                    }
                }
                
                Text("\(total) items")
            }
            .toolbar {
                //edit mode
                if editMode?.wrappedValue == .active {
                    if !ids.isEmpty {
                        ToolbarItem {
                            selectAllButton
                                .labelStyle(.titleOnly)
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        cancelEditModeButton
                            .fontWeight(.semibold)
                    }
                    
                    ToolbarItemGroup(placement: .status) {
                        Spacer()
                        Menu {
                            if !ids.isEmpty {
                                selectAllButton
                            }

                            Section {
                                cancelEditModeButton
                            }
                        } label: {
                            HStack {
                                if pick.isAll {
                                    Text("All")
                                } else {
                                    Text(selection.count, format: .number)
                                }
                                Text(Image(systemName: "chevron.up.chevron.down"))
                            }
                                .imageScale(.small)
                                .lineLimit(1)
                        }
                            .tint(.secondary)
                        Spacer()
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        RaindropsMenu(pick)
                    }
                }
                //regular
                else {
                    ToolbarItemGroup {
                        if !ids.isEmpty {
                            EditButton {
                                Label("Edit", systemImage: "checkmark.circle")
                            }
                                .labelStyle(.iconOnly)
                        }
                        
                        if sizeClass == .regular {
                            SortRaindropsButton(find)
                            ViewConfigRaindropsButton(find)
                        }
                    }
                    
                    if isSearching, sizeClass == .compact, !ids.isEmpty {
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
