import SwiftUI
import API
import UI
import Backport

public struct FindByPicker {
    @EnvironmentObject private var dispatch: Dispatcher
    @Binding var selection: Set<FindBy>
    
    public init(selection: Binding<Set<FindBy>>) {
        self._selection = selection
    }
}

extension FindByPicker: View {
    public var body: some View {
        Backport.List(selection: $selection) {
            SystemCollections<FindBy>(0, -1)
            
            DisclosureGroup {
                SimpleFilters<FindBy>()
            } label: {
                Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
            }
                .listItemTint(.secondary)
            
            CollectionGroups<FindBy>()
            
            TagsSection<FindBy>()
            
            SystemCollections<FindBy>(-99)
        }
            #if os(iOS)
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            #endif
            .labelStyle(.sidebar)
            .collectionsAnimation()
            .filtersAnimation()
            //menu
            .backport.contextMenu(forSelectionType: FindBy.self) {
                CollectionsMenu($0)
                TagsMenu($0)
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
