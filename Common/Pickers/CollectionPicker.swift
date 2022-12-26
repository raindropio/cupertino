import SwiftUI
import API
import Backport

public func CollectionPicker(_ selection: Binding<Int?>, system: [Int] = []) -> some View {
    _Optional(selection: selection, system: system)
}

public func CollectionPicker(_ selection: Binding<Int>, system: [Int] = []) -> some View {
    _Strict(selection: selection, system: system)
}

//MARK: - Main implementation
fileprivate struct _Optional {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var search = ""

    @Binding var selection: Int?
    var system: [Int]
}

extension _Optional: View {
    var body: some View {
        Backport.List(selection: $selection) {
            if search.isEmpty {
                if system.contains(-1) {
                    SystemCollections<Int>(-1)
                }
                
                CollectionGroups<UserCollection.ID>()
                
                if system.contains(-99) {
                    SystemCollections<Int>(-99)
                }
            } else {
                FindCollections(search: search)
            }
        }
            #if os(iOS)
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            #endif
            .collectionsAnimation()
            //search
            .searchable(text: $search)
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
            .collectionEvents()
    }
}

//MARK: - Support non-optional binding
fileprivate struct _Strict: View {
    @State private var local: Int?
    
    @Binding var selection: Int
    var system: [Int]
    
    var body: some View {
        _Optional(selection: $local, system: system)
            .task(id: selection) {
                local = selection
            }
            .onChange(of: local) {
                selection = $0 ?? -1
            }
    }
}
