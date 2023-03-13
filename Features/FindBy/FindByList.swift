import SwiftUI
import API
import UI

public struct FindByList {
    @EnvironmentObject private var dispatch: Dispatcher
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    @Environment(\.isSearching) private var isSearching
    @AppStorage("filters-expanded") private var filtersExpanded = false
    @AppStorage("tags-expanded") private var tagsExpanded = false

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
    
    private var isEditing: Bool {
        #if canImport(UIKit)
        editMode?.wrappedValue == .active
        #else
        false
        #endif
    }
}

extension FindByList: View {
    public var body: some View {
        List(selection: $selection) {
            if search.isEmpty {
                if !isEditing {
                    Section {
                        SystemCollections<FindBy>(0, -1)
                    }
                }
                
                UserCollections<FindBy>()
                
                DisclosureSection(
                    "Filters",
                    isExpanded: $filtersExpanded,
                    content: SimpleFilters<FindBy>.init
                )
                    .modifier(SimpleFilters.Optional())
                
                DisclosureSection(
                    "Tags",
                    isExpanded: $tagsExpanded,
                    content: AllTags<FindBy>.init
                )
                    .modifier(AllTags.Optional())
                
                if !isEditing {
                    Section {
                        SystemCollections<FindBy>(-99)
                    }
                }
            } else {
                FindCollections<FindBy>(search)
                
                Section("Tags") {
                    AllTags<FindBy>(search: search)
                }
                    .modifier(AllTags.Optional(search: search))
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
            .animation(.default, value: filtersExpanded)
            .animation(.default, value: tagsExpanded)
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
