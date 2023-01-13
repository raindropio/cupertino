import SwiftUI
import API
import UI
import Backport

public struct FindByList {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.editMode) private var editMode
    @Environment(\.isSearching) private var isSearching
    @AppStorage("tags-expanded") private var isExpanded = true

    @Binding var selection: Set<FindBy>
    var search: String
    
    public init(selection: Binding<Set<FindBy>>, search: String = "") {
        self._selection = selection
        self.search = search
    }
}

extension FindByList {
    @ViewBuilder
    func contextMenu(_ selection: Set<FindBy>) -> some View {
        if !selection.isEmpty {
            if selection.allSatisfy({ !$0.isSearching }) {
                CollectionsMenu(selection)
            } else if selection.allSatisfy({ $0.isSearching }) {
                TagsMenu(selection)
            }
        }
    }
    
    @ViewBuilder
    func bottomBar() -> some View {
        if editMode?.wrappedValue == .active {
            contextMenu(selection)
                .labelStyle(.titleOnly)
        }
    }
}

extension FindByList: View {
    public var body: some View {
        Backport.List(selection: $selection) {
            if search.isEmpty {
                Section {
                    if editMode?.wrappedValue != .active {
                        SystemCollections<FindBy>(0, -1)
                    }
                }
                
                UserCollections<FindBy>()
                
                DisclosureSection("Tags", isExpanded: $isExpanded) {
                    Tags<FindBy>()
                }
                
                Section {
                    if editMode?.wrappedValue != .active {
                        SystemCollections<FindBy>(-99)
                    }
                }
            } else {
                FindCollections<FindBy>(search)
                
                Section("Tags") {
                    Tags<FindBy>(search: search)
                }
            }
        }
            #if os(iOS)
            .listStyle(.insetGrouped)
            .headerProminence(search.isEmpty ? .increased : .standard)
            #endif
            .labelStyle(.sidebar)
            .collectionsAnimation()
            .tagsAnimation()
            //menu
            .backport.contextMenu(forSelectionType: FindBy.self, menu: contextMenu)
            //toolbar
            .toolbar {
                ToolbarItem {
                    if editMode?.wrappedValue != .active {
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
                
                ToolbarItemGroup(placement: .bottomBar, content: bottomBar)
            }
            //reload
            .refreshable {
                try? await dispatch(CollectionsAction.load, FiltersAction.reload())
            }
            .reload {
                try? await dispatch(CollectionsAction.load, FiltersAction.reload())
            }
    }
}
