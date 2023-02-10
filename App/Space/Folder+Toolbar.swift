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
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @EnvironmentObject private var app: AppRouter

        var find: FindBy
        @Binding var selection: Set<Raindrop.ID>
        var ids: [Raindrop.ID]
        
        private var pick: RaindropsPick {
            selection.count == ids.count ? .all(find): .some(selection)
        }
        
        func body(content: Content) -> some View {
            content
            .toolbarRole(.browser)
            .navigationBarBackButtonHidden(editMode?.wrappedValue == .active)
            .toolbar {
                ToolbarItemGroup {
                    if editMode?.wrappedValue == .active {
                        Button(pick.isAll ? "Deselect all" : "Select all") {
                            selection = .init(pick.isAll ? [] : ids)
                        }
                    } else {
                        if sizeClass == .regular {
                            SortRaindropsButton(find)
                            CustomizeRaindropsButton(find)
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
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    if editMode?.wrappedValue == .active {
                        EditButton()
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .status) {
                    if editMode?.wrappedValue == .active {
                        Text("\(selection.count) selected")
                            .lineLimit(1)
                            .layoutPriority(-1)
                    }
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    if editMode?.wrappedValue == .active {
                        RaindropsMenu(pick)
                    }
                }
            }
        }
    }
}
