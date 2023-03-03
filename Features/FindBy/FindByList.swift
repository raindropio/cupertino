import SwiftUI
import API
import UI

public struct FindByList {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.editMode) private var editMode
    @Environment(\.isSearching) private var isSearching
    @AppStorage("filters-expanded") private var filtersExpanded = false
    @AppStorage("tags-expanded") private var tagsExpanded = true

    @Binding var selection: FindBy?
    var search: String
    
    public init(selection: Binding<FindBy?>, search: String = "") {
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
}

extension FindByList: View {
    public var body: some View {
        List(selection: $selection) {
            if search.isEmpty {
                if editMode?.wrappedValue != .active {
                    SystemCollections<FindBy>(0, -1)
                    
                    DisclosureGroup(
                        isExpanded: $filtersExpanded,
                        content: SimpleFilters<FindBy>.init
                    ) {
                        Label("Filters", systemImage: "circle.grid.2x2")
                    }
                        .listItemTint(.monochrome)
                }
                
                UserCollections<FindBy>()
                
                DisclosureSection(
                    "Tags",
                    isExpanded: $tagsExpanded,
                    content: AllTags<FindBy>.init
                )
                
                if editMode?.wrappedValue != .active {
                    SystemCollections<FindBy>(-99)
                }
            } else {
                FindCollections<FindBy>(search)
                
                Section("Tags") {
                    AllTags<FindBy>(search: search)
                }
            }
        }
            #if os(iOS)
            .listStyle(.insetGrouped)
            .headerProminence(search.isEmpty ? .increased : .standard)
            .environment(\.defaultMinListRowHeight, 44)
            #endif
            .labelStyle(.sidebar)
            .collectionsAnimation()
            .tagAnimations()
            //menu
            .contextMenu(forSelectionType: FindBy.self, menu: contextMenu)
            //reload
            .refreshable {
                try? await dispatch(CollectionsAction.load, FiltersAction.reload())
            }
            .reload {
                try? await dispatch(CollectionsAction.load, FiltersAction.reload())
            }
    }
}
