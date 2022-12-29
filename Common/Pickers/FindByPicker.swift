import SwiftUI
import API
import UI
import Backport

public struct FindByPicker {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.editMode) private var editMode
    @Environment(\.isSearching) private var isSearching
    
    @Binding var selection: Set<FindBy>
    var search: String
    
    public init(selection: Binding<Set<FindBy>>, search: String = "") {
        self._selection = selection
        self.search = search
    }
}

extension FindByPicker {
    @ViewBuilder
    func contextMenu(_ selection: Set<FindBy>) -> some View {
        if selection.isEmpty {
            Section { CollectionsMenu(selection) }
            Section { TagsMenu(selection) }
        } else if selection.allSatisfy({ !$0.isSearching }) {
            CollectionsMenu(selection)
        } else if selection.allSatisfy({ $0.isSearching }) {
            TagsMenu(selection)
        }
    }
    
    @ViewBuilder
    func bottomBar() -> some View {
        if editMode?.wrappedValue == .active {
            ControlGroup {
                contextMenu(selection)
            }
                .controlGroupStyle(.tabs)
        }
    }
}

extension FindByPicker: View {
    public var body: some View {
        Backport.List(selection: $selection) {
            if search.isEmpty {
                Section {
                    if editMode?.wrappedValue != .active {
                        SystemCollections<FindBy>(0, -1)
                        FiltersDisclosure<FindBy>()
                    }
                }
                
                UserCollections<FindBy>()
                TagsSection<FindBy>()
                
                Section {
                    if editMode?.wrappedValue != .active {
                        SystemCollections<FindBy>(-99)
                    }
                }
            } else {
                Section {
                    if editMode?.wrappedValue != .active {
                        Label("Search \(search)", systemImage: "magnifyingglass")
                            .raindropsCountBadge(search)
                            .backport.tag(FindBy(search))
                    }
                }
                
                FindCollections<FindBy>(search)
                FindTags<FindBy>(search)
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
                ToolbarItem(placement: .destructiveAction, content: EditButton.init)
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
