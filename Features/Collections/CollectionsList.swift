import SwiftUI
import API

public func CollectionsList(_ selection: Binding<Int?>, system: [Int] = []) -> some View {
    _Optional(selection: selection, system: system)
}

public func CollectionsList(_ selection: Binding<Int>, system: [Int] = []) -> some View {
    _Strict(selection: selection, system: system)
}

//MARK: - Main implementation
fileprivate struct _Optional {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var search = ""
    @FocusState private var searching: Bool

    @Binding var selection: Int?
    var system: [Int]
}

extension _Optional: View {
    var body: some View {
        List(selection: $selection) {
            Section {
                Label {
                    TextField("Search", text: $search)
                        .focused($searching)
                        #if canImport(UIKit)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.webSearch)
                        #endif
                        .autoFocus()
                } icon: {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.medium)
                }
                    .onTapGesture {
                        searching = true
                    }
                    .listRowBackground(Color.primary.opacity(0.07))
                    .listItemTint(.monochrome)
            }
            
            if search.isEmpty {
                if system.contains(-1) {
                    SystemCollections<Int>(-1)
                }
                
                UserCollections<UserCollection.ID>()
                
                if system.contains(-99) {
                    SystemCollections<Int>(-99)
                }
            } else {
                FindCollections<Int>(search)
            }
        }
            ._safeAreaInsets(.init(top: -20, leading: 0, bottom: 0, trailing: 0))
            #if os(iOS)
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            #endif
            .labelStyle(.sidebar)
            .collectionsAnimation()
            //menu
            .contextMenu(forSelectionType: FindBy.self) { selection in
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
