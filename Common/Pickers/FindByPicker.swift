import SwiftUI
import API
import UI
import Backport

public struct FindByPicker {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.editMode) private var editMode
    
    @Binding var selection: Set<FindBy>
    
    public init(selection: Binding<Set<FindBy>>) {
        self._selection = selection
    }
}

extension FindByPicker {
    @ViewBuilder
    func contextMenu(_ selection: Set<FindBy>) -> some View {
        if selection.allSatisfy({ $0.isSearching }) {
            TagsMenu(selection)
        } else if selection.allSatisfy({ !$0.isSearching }) {
            CollectionsMenu(selection)
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

extension FindByPicker: View {
    public var body: some View {
        Backport.List(selection: $selection) {
            Section {
                if editMode?.wrappedValue != .active {
                    SystemCollections<FindBy>(0, -1)
                    
                    DisclosureGroup {
                        SimpleFilters<FindBy>()
                    } label: {
                        Label("Filters", systemImage: "circle.grid.2x2")
                    }
                }
            }
            
            CollectionGroups<FindBy>()
            TagsSection<FindBy>()
            
            Section {
                if editMode?.wrappedValue != .active {
                    SystemCollections<FindBy>(-99)
                }
            }
        }
            #if os(iOS)
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            #endif
            .labelStyle(.sidebar)
            .collectionsAnimation()
            .filtersAnimation()
            //menu
            .backport.contextMenu(forSelectionType: FindBy.self, menu: contextMenu)
            //toolbar
            .toolbar {
                ToolbarItem {
                    EditButton()
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
