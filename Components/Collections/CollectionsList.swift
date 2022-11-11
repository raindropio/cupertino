import SwiftUI
import API

struct CollectionsList<C: View> {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var search = ""

    @Binding var selection: Int?
    var matching: CollectionsListMatching = .all
    var searchable: Bool = true
    var custom: (() -> C)?
}

extension CollectionsList: View {
    var body: some View {
        List(selection: $selection) {
            if search.isEmpty {
                Section {
                    if matching == .all {
                        SystemCollectionItem(id: 0)
                            .tag(0)
                    }
                    if matching != .nestable {
                        SystemCollectionItem(id: -1)
                            .tag(-1)
                    }
                    custom?()
                }
                
                CollectionsTree()
                
                if matching == .all {
                    Section {
                        SystemCollectionItem(id: -99)
                            .tag(-99)
                    }
                }
            } else {
                SearchCollections(search: search)
            }
        }
            //appearance
            #if os(iOS)
            .modifier(Animation())
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            #endif
            //features
            .modifier(Menus())
            .modifier(Search(enabled: searchable, search: $search))
            .overlay(content: Empty.init)
            //reload
            .refreshable {
                try? await dispatch(CollectionsAction.load)
            }
            .task(priority: .background) {
                try? await dispatch(CollectionsAction.load)
            }
    }
}

enum CollectionsListMatching {
    case all
    case nestable
    case insertable
}

extension CollectionsList where C == EmptyView {
    init(selection: Binding<Int?>) {
        _selection = selection
        custom = nil
    }
}
