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
            CollectionGroups<FindBy>()
            SystemCollections<FindBy>(-99)
        }
            #if os(iOS)
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            #endif
            .collectionsAnimation()
            //menu
            .backport.contextMenu(forSelectionType: FindBy.self) { selection in
                CollectionsMenu(selection)
            }
            //reload
            .refreshable {
                try? await dispatch(CollectionsAction.load)
            }
            .reload {
                try? await dispatch(CollectionsAction.load)
            }
    }
}
